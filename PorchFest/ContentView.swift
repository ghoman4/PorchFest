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
            //Background color
            Color("white").ignoresSafeArea()
            // MapView with user tracking inside a circle
            if let lastKnownLocation = locationDataManager.lastKnownLocation {
                GeometryReader { geometry in
                    MapViewRepresentable(region: $region, trackingMode: $trackingMode)
                        .onAppear {
                            updateRegion(lastKnownLocation)
                        }
                        .clipShape(Circle()) // Clip the map to a circle
                        .overlay(Circle().stroke(Color("secondary"), lineWidth: 4)) // Border
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5) // Add shadow
                        .padding(10) // Extra padding
                        .frame(maxWidth: min(geometry.size.width - 40, 500)) // Padding & max width
                        .aspectRatio(1, contentMode: .fit) // aspect ratio of 1 (perfect circle)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center map

                }
                .edgesIgnoringSafeArea(.all)
            } else {
                VStack {
                    Text("Locating...")
                    ProgressView()
                }
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
        
    }
}

#Preview {
    ContentView()
}
