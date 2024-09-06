import CoreLocation

class LocationDataManager : NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var isWithinRange = false
    @Published var distanceFromTarget: Double = 0.0 // Distance in meters

    let targetLocation = CLLocation(latitude: 42.427425, longitude: -76.485666) // Target coordinates
    let targetRadiusInMeters: Double = 30.48

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation() // Start continuous location updates
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            authorizationStatus = .authorizedWhenInUse
            
        case .restricted:
            // Handle case when location services are restricted
            authorizationStatus = .restricted
            
        case .denied:
            authorizationStatus = .denied
            
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            
        default:
            break
        }
    }
    
    // Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastKnownLocation = location.coordinate
        
        // Calculate the distance from the target location
        let userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let distanceInMeters = userLocation.distance(from: targetLocation) // Distance to target in meters
        distanceFromTarget = distanceInMeters

        // Check if the user is within the target range
        isWithinRange = distanceInMeters <= targetRadiusInMeters
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
