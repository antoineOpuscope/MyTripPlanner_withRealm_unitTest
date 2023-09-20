//
//  CLLocationCoordinate2DTests.swift
//  MyTripPlannerTests
//
//  Created by Antoine Omnès on 20/09/2023.
//

import XCTest
@testable import MyTripPlanner
import Foundation
import CoreLocation

final class CLLocationCoordinate2DTests: XCTestCase {

    func testUnequalCoordinates() {
        let coordinate1 = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let coordinate2 = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060) // Different coordinates
        
        XCTAssertFalse(coordinate1 == coordinate2)
    }

    func testCoordinatesWithinTolerance() {
        let coordinate1 = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let coordinate2 = CLLocationCoordinate2D(latitude: 37.7750, longitude: -122.4195) // Slightly different coordinates
        
        XCTAssertTrue(coordinate1 == coordinate2)
    }

    func testCoordinatesOutsideTolerance() {
        let coordinate1 = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let coordinate2 = CLLocationCoordinate2D(latitude: 37.7800, longitude: -122.4200) // Further apart coordinates
        
        XCTAssertFalse(coordinate1 == coordinate2)
    }
}
