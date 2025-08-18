import SwiftUI
import CoreLocation

struct Driver: Identifiable {
    let id: String
    let name: String
    let services: [String]
    let distance: Double
    let rating: Double
    let reviews: Int
    let responseTime: String
    let responseRate: String
    let image: String
}

struct DriverDirectory: View {
    @StateObject private var locationManager = LocationManager()
    @State private var errorMessage: String?
    @State private var isListLoaded = false
    
    let drivers: [Driver] = [
        Driver(id: "1", name: "John Doe", services: ["Private Driver", "Airport Shuttle Service"], distance: 1.2, rating: 4.8, reviews: 120, responseTime: "5 mins", responseRate: "100%", image: "https://randomuser.me/api/portraits/men/1.jpg"),
        Driver(id: "2", name: "Lisa Wong", services: ["Limo Service", "Private Chauffeur Service"], distance: 3.8, rating: 4.4, reviews: 75, responseTime: "5 mins", responseRate: "100%", image: "https://randomuser.me/api/portraits/women/7.jpg"),
        Driver(id: "3", name: "Michael Brown", services: ["Private Driver", "Black Car Service"], distance: 2.5, rating: 4.9, reviews: 150, responseTime: "5 mins", responseRate: "98%", image: "https://randomuser.me/api/portraits/men/3.jpg"),
        Driver(id: "4", name: "Sarah Davis", services: ["Airport Shuttle Service", "Private Chauffeur Service"], distance: 4.0, rating: 4.6, reviews: 90, responseTime: "5 mins", responseRate: "100%", image: "https://randomuser.me/api/portraits/women/4.jpg"),
        Driver(id: "5", name: "David Lee", services: ["Private Driver", "Limo Service"], distance: 5.2, rating: 4.7, reviews: 110, responseTime: "5 mins", responseRate: "99%", image: "https://randomuser.me/api/portraits/men/5.jpg"),
        Driver(id: "6", name: "Emily Clark", services: ["Limo Service", "Private Driver"], distance: 3.1, rating: 4.5, reviews: 80, responseTime: "5 mins", responseRate: "100%", image: "https://randomuser.me/api/portraits/women/6.jpg"),
        Driver(id: "7", name: "James Wilson", services: ["Private Chauffeur Service", "Airport Shuttle Service"], distance: 6.5, rating: 4.8, reviews: 130, responseTime: "5 mins", responseRate: "97%", image: "https://randomuser.me/api/portraits/men/7.jpg"),
        Driver(id: "8", name: "Anna Martinez", services: ["Luxury SUV Service", "Private Driver"], distance: 2.9, rating: 4.6, reviews: 95, responseTime: "5 mins", responseRate: "100%", image: "https://randomuser.me/api/portraits/women/8.jpg"),
        Driver(id: "9", name: "Robert Taylor", services: ["Private Driver", "Luxury SUV Service"], distance: 4.8, rating: 4.9, reviews: 140, responseTime: "5 mins", responseRate: "98%", image: "https://randomuser.me/api/portraits/men/9.jpg"),
        Driver(id: "10", name: "Sophie Harris", services: ["Airport Shuttle Service", "Private Chauffeur Service"], distance: 5.5, rating: 4.7, reviews: 100, responseTime: "5 mins", responseRate: "99%", image: "https://randomuser.me/api/portraits/women/10.jpg")
    ]
    
    let serviceIcons: [String: String] = [
        "Private Driver": "car.fill",
        "Limo Service": "car.fill",
        "Luxury SUV Service": "car.fill",
        "Black Car Service": "car.fill",
        "Airport Shuttle Service": "airplane",
        "Private Chauffeur Service": "car.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white // Replaced blue gradient with white background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        Text("Nearby Driving Pros")
                            .font(.custom("Nunito-Bold", size: 24))
                            .foregroundColor(.black) // Changed to black
                            .padding(.top, 10) // Reduced top padding
                            .padding(.bottom, 8)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
                            .scaleEffect(isListLoaded ? 1 : 0.8)
                            .opacity(isListLoaded ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: isListLoaded)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.custom("Nunito-Regular", size: 14))
                                .foregroundColor(.red)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                        
                        ForEach(drivers.sorted { $0.distance < $1.distance }) { driver in
                            NavigationLink(destination: DriverDetailView(driver: driver)) {
                                DriverCard(driver: driver, serviceIcons: serviceIcons)
                                    .scaleEffect(isListLoaded ? 1 : 0.95)
                                    .opacity(isListLoaded ? 1 : 0)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(drivers.firstIndex(where: { $0.id == driver.id }) ?? 0) * 0.1), value: isListLoaded)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .background(Color(.sRGB, red: 0.95, green: 0.95, blue: 0.95)) // Light grey background
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            locationManager.requestLocation { error in
                if let error = error {
                    errorMessage = "Permission to access location was denied: \(error.localizedDescription)"
                    print("Location error: \(error.localizedDescription)")
                }
            }
            withAnimation {
                isListLoaded = true
            }
        }
    }
}

struct DriverCard: View {
    let driver: Driver
    let serviceIcons: [String: String]
    @State private var isButtonHovered = false
    
    var body: some View {
        ZStack {
            Color.white // White card background
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(driver.name)
                            .font(.custom("Nunito-Bold", size: 20))
                            .foregroundColor(.black)
                            .padding(.bottom, 6)
                        
                        ForEach(driver.services, id: \.self) { service in
                            HStack {
                                Image(systemName: serviceIcons[service] ?? "briefcase.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 16))
                                Text(service)
                                    .font(.custom("Nunito-Regular", size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 4)
                        }
                        
                        HStack {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: i <= Int(driver.rating.rounded()) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12))
                            }
                            Text("(\(driver.reviews) reviews)")
                                .font(.custom("Nunito-Regular", size: 12))
                                .foregroundColor(.gray)
                                .padding(.leading, 5)
                        }
                        .padding(.bottom, 6)
                        
                        Text("\(driver.distance, specifier: "%.1f") miles away")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.black)
                            .padding(.bottom, 10)
                    }
                    
                    Spacer()
                    
                    VStack {
                        AsyncImage(url: URL(string: driver.image)) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    .shadow(color: .white.opacity(0.6), radius: 5, x: 0, y: 0)
                                    .onAppear {
                                        print("Image loaded successfully: \(driver.image)")
                                    }
                            case .failure(let error):
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    .onAppear {
                                        print("Image failed to load: \(driver.image), error: \(error.localizedDescription)")
                                    }
                            case .empty:
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    .onAppear {
                                        print("Image loading: \(driver.image)")
                                    }
                            @unknown default:
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            }
                        }
                        .padding(.bottom, 8)
                        
                        Text("ETA: \(driver.responseTime)")
                            .font(.custom("Nunito-Regular", size: 12))
                            .foregroundColor(.black)
                        
                        Text("Response Rate: \(driver.responseRate)")
                            .font(.custom("Nunito-Regular", size: 12))
                            .foregroundColor(.black)
                    }
                }
                
                Button(action: {}) {
                    Text("Request Service")
                        .font(.custom("Nunito-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.init(red: 0.2, green: 0.7, blue: 0.2), .init(red: 0.1, green: 0.5, blue: 0.1), .init(red: 0.05, green: 0.3, blue: 0.05)]), startPoint: .leading, endPoint: .trailing) // Green gradient
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                        .scaleEffect(isButtonHovered ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isButtonHovered)
                }
                .onHover { hovering in
                    isButtonHovered = hovering
                }
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        .padding(.vertical, 8)
    }
}

struct DriverDetailView: View {
    let driver: Driver
    
    var body: some View {
        VStack {
            Text("Driver Detail: \(driver.name)")
                .font(.custom("Nunito-Bold", size: 24))
                .foregroundColor(.black)
                .padding()
            Spacer()
        }
        .background(Color.white) // Replaced blue gradient with white
            .ignoresSafeArea()
        .navigationTitle(driver.name)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(completion: @escaping (Error?) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
            completion(nil)
        } else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location services are disabled"]))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates if needed
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

struct DriverDirectory_Previews: PreviewProvider {
    static var previews: some View {
        DriverDirectory()
    }
}
