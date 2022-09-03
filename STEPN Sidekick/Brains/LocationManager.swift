//
//  LocationManager.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey
//
//  Last updated 3 Sep 22
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    var authorizedLocation = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuth()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
    }
    
    func resumeLocationUpdates() {
        manager.startUpdatingLocation()
    }
    
    func checkAuth() {
        if manager.authorizationStatus == .authorizedWhenInUse {
            authorizedLocation = true
        } else {
            authorizedLocation = false
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            print("uh oh spaghettis: not determined")
        case .restricted:
            print("uh oh spaghettis: restricted")
        case .denied:
            print("uh oh spaghettis: denied")
        case .authorizedAlways:
            print("auth always")
        case .authorizedWhenInUse:
            print("uh oh spaghettis: auth when in use")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}
