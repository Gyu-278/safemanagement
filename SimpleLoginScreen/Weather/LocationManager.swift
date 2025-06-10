//
//  LocationManager.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/1/25.
//

// Weather/LocationManager.swift
// Weather/LocationManager.swift
import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        self.requestLocation()
    }

    func requestLocation() {
        isLoading = true
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        print("Location error: \(error.localizedDescription)")
    }
}

