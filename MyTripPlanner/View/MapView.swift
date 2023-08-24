//
//  MapView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import MapKit
import Combine

struct MapView: View {
        
    @ObservedObject var project: Project
    // AOM - @ObservedObject not needed because we wont edit it
    var location: Location?
    
    var isContextMenuAllowed: Bool
    
    @EnvironmentObject private var stateController: StateController
    
    @State private var isCreateLocationSheetPresented: Bool = false
    
    @Binding var isAddingLocation: Bool
    @State var tappedCoordinates: Coordinate? = nil
    
    struct Coordinate: Identifiable {
        let id = UUID()
        var tappedCoordinates: CLLocationCoordinate2D

        init(tappedCoordinates: CLLocationCoordinate2D) {
            self.tappedCoordinates = tappedCoordinates
        }
    }
        
    @Binding private var cameraPosition: MapCameraPosition
    
    init(project: Project, isContextMenuAllowed: Bool, cameraPosition: Binding<MapCameraPosition>, isAddingLocation: Binding<Bool> = .constant(false), location: Location? = nil) {
        _project = ObservedObject(wrappedValue: project)
        self.location = location
        self.isContextMenuAllowed = isContextMenuAllowed
        //https://sarunw.com/posts/binding-initialization/
        _isAddingLocation = isAddingLocation
        
        _cameraPosition = cameraPosition
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapReader { reader in
                    ZStack {
                        Map(
                            position: $cameraPosition,
                            interactionModes: [.all]
                        )
                        {
                            if isAddingLocation {
                                
                            } else if let location {
                                ForEach([Pin(location: location)], id:\.id) { pin in
                                    Annotation("", coordinate: pin.coordinate) {
                                        PinView(pin: pin)
                                    }
                                }
                            } else {
                                ForEach(project.pins, id:\.id) { pin in
                                    Annotation("", coordinate: pin.coordinate) {
                                        NavigationLink {
                                            LocationView(project: self.project, location: pin.location)
                                        } label: {
                                            PinView(pin: pin)
                                                .contextMenu(ContextMenu(menuItems: {
                                                    Button(role: .destructive) {
                                                        stateController.removeLocation(project: self.project, location: pin.location)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }))
                                        }
                                    }
                                }
                            }
                        }
                        .onTapGesture(perform: { screenCoord in
                            if self.isAddingLocation {
                                if let tappedCoordinate = reader.convert(screenCoord, from: .local) {
                                    isAddingLocation = false
                                    tappedCoordinates = Coordinate(tappedCoordinates: tappedCoordinate)
                                    self.isCreateLocationSheetPresented = true
                                }
                            }
                        })
                        .mapControls{
                            MapCompass()
                        }
                        .mapStyle(.standard(elevation: .flat))
                        .sheet(item: $tappedCoordinates) { _ in
                            if let tappedCoordinates {
                                LocationCreationView(newTappedCoordinate: tappedCoordinates.tappedCoordinates, project: project)
                                    .environmentObject(stateController)
                            }
                        }
                    }
                }
            }
        }
    }
}


struct MapView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var locationManager = LocationManager()
        @State private var cameraPosition: MapCameraPosition = .automatic

        var body: some View {
            MapView(project: TestData.project, isContextMenuAllowed: true, cameraPosition: $cameraPosition)
        }
    }

    static var previews: some View {
        Preview()
    }
}
