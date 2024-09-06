import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.427425, longitude: -76.485666), // Default to target location
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Set default zoom level
    )
    @State private var trackingMode: MKUserTrackingMode = .follow
    
    var body: some View {
        ZStack {
            // MapView with user tracking
            if let lastKnownLocation = locationDataManager.lastKnownLocation {
                MapViewRepresentable(region: $region, trackingMode: $trackingMode)
                    .onAppear {
                        updateRegion(lastKnownLocation)
                    }
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Locating...")
                ProgressView()
            }
            
            // Location information UI
            VStack {
                Spacer()
                locationStatusView
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            }
        }
    }
    
    // UI to show user status and distance to the target
    private var locationStatusView: some View {
        VStack {
            if let status = locationDataManager.authorizationStatus {
                switch status {
                case .authorizedWhenInUse:
                    Text("Your current location:")
                    Text("Latitude: \(locationDataManager.lastKnownLocation?.latitude.description ?? "Error loading")")
                    Text("Longitude: \(locationDataManager.lastKnownLocation?.longitude.description ?? "Error loading")")
                        .padding(.bottom)
                    
                    if locationDataManager.isWithinRange {
                        Text("You are within 100 feet of the target location!")
                    } else {
                        Text("You are \(String(format: "%.2f", locationDataManager.distanceFromTarget * 3.28084)) feet away from the target.")
                    }
                    
                case .restricted, .denied:
                    Text("Location access restricted or denied.")
                    
                case .notDetermined:
                    Text("Locating...")
                    ProgressView()
                    
                default:
                    Text("Default")
                    ProgressView()
                }
            } else {
                ProgressView()
            }
        }
    }
    
    // Update map region when location changes
    private func updateRegion(_ location: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Adjust zoom as needed
        )
    }
}

#Preview {
    ContentView()
}
