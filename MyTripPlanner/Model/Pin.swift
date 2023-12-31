//
//  Pin.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 18/08/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import RealmSwift

class Pin: Identifiable {
    let id: UInt64
    let location: Location
    let name: String
    let coordinate: CLLocationCoordinate2D
    let icon: String
    let color: Color
    
    init(location: Location) {
        self.location = location
        self.id = location.id
        self.name = location.name
        self.coordinate = location.coordinate
        self.icon = location.icon
        self.color = location.color
    }
}
