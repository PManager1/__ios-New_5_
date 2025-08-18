/*

import SwiftUI
import MapKit
import CoreLocation

// Renamed Location Manager
class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.region.center = location.coordinate
        }
    }
}

struct CurrentLocation: View {
    @StateObject private var userLocationManager = UserLocationManager()
    
    var body: some View {
        ZStack {
            // Map showing current location
            Map(coordinateRegion: $userLocationManager.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Current Location")
                    .font(.headline)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.bottom, 40)
            }
        }
        .navigationTitle("First Screen")
    }
}

struct CurrentLocation_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CurrentLocation()
        }
    }
}

*/