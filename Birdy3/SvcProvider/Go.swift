//import SwiftUI
//import MapKit
//import CoreLocation
//
//// Trip model with Codable conformance
//struct Trip: Identifiable, Codable {
//    let id: String
//    let from: String?
//    let to: String?
//    let distance: String?
//    let estimatedTime: String?
//    let price: Double?
//    let riderName: String?
//    let pickupCoords: CLLocationCoordinate2D
//    let dropOffCoords: CLLocationCoordinate2D
//    
//    enum CodingKeys: String, CodingKey {
//        case id, from, to, distance, estimatedTime, price, riderName
//        case pickupCoords = "pickupCoords"
//        case dropOffCoords = "dropOffCoords"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        from = try container.decodeIfPresent(String.self, forKey: .from)
//        to = try container.decodeIfPresent(String.self, forKey: .to)
//        distance = try container.decodeIfPresent(String.self, forKey: .distance)
//        estimatedTime = try container.decodeIfPresent(String.self, forKey: .estimatedTime)
//        price = try container.decodeIfPresent(Double.self, forKey: .price)
//        riderName = try container.decodeIfPresent(String.self, forKey: .riderName)
//        
//        let pickupDict = try container.decode([String: Double].self, forKey: .pickupCoords)
//        pickupCoords = CLLocationCoordinate2D(
//            latitude: pickupDict["latitude"] ?? 0.0,
//            longitude: pickupDict["longitude"] ?? 0.0
//        )
//        let dropoffDict = try container.decode([String: Double].self, forKey: .dropOffCoords)
//        dropOffCoords = CLLocationCoordinate2D(
//            latitude: dropoffDict["latitude"] ?? 0.0,
//            longitude: dropoffDict["longitude"] ?? 0.0
//        )
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encodeIfPresent(from, forKey: .from)
//        try container.encodeIfPresent(to, forKey: .to)
//        try container.encodeIfPresent(distance, forKey: .distance)
//        try container.encodeIfPresent(estimatedTime, forKey: .estimatedTime)
//        try container.encodeIfPresent(price, forKey: .price)
//        try container.encodeIfPresent(riderName, forKey: .riderName)
//        try container.encode(["latitude": pickupCoords.latitude, "longitude": pickupCoords.longitude], forKey: .pickupCoords)
//        try container.encode(["latitude": dropOffCoords.latitude, "longitude": dropOffCoords.longitude], forKey: .dropOffCoords)
//    }
//    
//    // Custom initializer for mock data
//    init(id: String, from: String?, to: String?, distance: String?, estimatedTime: String?, price: Double?, riderName: String?, pickupCoords: CLLocationCoordinate2D, dropOffCoords: CLLocationCoordinate2D) {
//        self.id = id
//        self.from = from
//        self.to = to
//        self.distance = distance
//        self.estimatedTime = estimatedTime
//        self.price = price
//        self.riderName = riderName
//        self.pickupCoords = pickupCoords
//        self.dropOffCoords = dropOffCoords
//    }
//}
//
//// User model
//struct User: Codable {
//    let driverProfile: DriverProfile?
//}
//
//struct DriverProfile: Codable {
//    let isOnline: Bool
//}
//
//// Placeholder functions (synchronous, no backend calls)
//func fetchUser() -> User {
//    return User(driverProfile: DriverProfile(isOnline: false))
//}
//
//func getTrips() -> [Trip] {
//    return [
//        Trip(
//            id: UUID().uuidString,
//            from: "123 Main St",
//            to: "456 Elm St",
//            distance: "5 miles",
//            estimatedTime: "15 mins",
//            price: 20.0,
//            riderName: "John Doe",
//            pickupCoords: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
//            dropOffCoords: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4294)
//        )
//    ]
//}
//
//func patchUserG(isOnline: Bool) {
//    print("Updated user online status to: \(isOnline)")
//}
//
//func getRouteCoordinates(start: CLLocationCoordinate2D, pickup: CLLocationCoordinate2D, dropoff: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
//    return [start, pickup, dropoff]
//}
//
//struct GoView: View {
//    @StateObject private var locationManager = GoLocationManager()
//    @State private var currentLocation: CLLocationCoordinate2D?
//    @State private var isOnline: Bool = false
//    @State private var toastMessage: String = ""
//    @State private var buttonText: String = ""
//    @State private var buttonColor: Color = .red
//    @State private var safetyModalVisible: Bool = false
//    @State private var trips: [Trip] = []
//    @State private var acceptedTripIds: [String] = []
//    @State private var declinedTripIds: [String] = []
//    @State private var isModalVisible: Bool = false
//    @State private var selectedTripId: String?
//    @State private var routeCoords: [CLLocationCoordinate2D] = []
//    @State private var debugLogs: [String] = []
//    @State private var opacity: Double = 0
//    @State private var buttonScale: CGFloat = 1
//    @State private var rippleScale: CGFloat = 0
//    @State private var toastOpacity: Double = 0
//    @State private var glowOpacity: Double = 0
//    @State private var bottomSheetOffset: CGFloat = UIScreen.main.bounds.height
//    
//    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//    
//    private let scaleFactor: CGFloat = 1.0
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // Map View
//                Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
//                    MapAnnotation(coordinate: annotation.coordinate) {
//                        annotation.view
//                    }
//                }
//                .edgesIgnoringSafeArea(.all)
//                
//                // Menu Button
//                VStack {
//                    HStack {
//                        Button(action: {
//                            print("Menu button tapped")
//                        }) {
//                            Image(systemName: "line.3.horizontal")
//                                .foregroundColor(.black)
//                                .padding(12)
//                                .background(Color.white.opacity(0.8))
//                                .clipShape(Circle())
//                                .shadow(radius: 4)
//                        }
//                        Spacer()
//                        Button(action: {
//                            print("Add Client tapped")
//                        }) {
//                            Text("+")
//                                .font(.system(size: 20))
//                                .foregroundColor(.white)
//                                .frame(width: 40, height: 40)
//                                .background(Color.blue)
//                                .clipShape(Circle())
//                                .shadow(radius: 4)
//                        }
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 40)
//                    Spacer()
//                }
//                
//                // Trip Badge
//                if isOnline && !trips.isEmpty {
//                    Button(action: {
//                        withAnimation {
//                            isModalVisible.toggle()
//                            if isModalVisible && !trips.isEmpty {
//                                selectedTripId = trips.first?.id
//                                updateMapMarkers(trip: trips.first)
//                            } else {
//                                selectedTripId = nil
//                                resetMapRegion()
//                            }
//                        }
//                    }) {
//                        Text("\(trips.count) Trip\(trips.count == 1 ? "" : "s") around you")
//                            .font(.system(size: 16))
//                            .foregroundColor(.white)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 20)
//                            .background(Color.green)
//                            .cornerRadius(20)
//                            .shadow(radius: 4)
//                    }
//                    .position(x: 80, y: UIScreen.main.bounds.height - 205 * scaleFactor)
//                }
//                
//                // Bottom Sheet Modal
//                if isModalVisible {
//                    VStack {
//                        Spacer()
//                        VStack {
//                            HStack {
//                                Text("Trip Radar (\(trips.count))")
//                                    .font(.system(size: 18))
//                                    .foregroundColor(.white)
//                                Spacer()
//                                Button(action: {
//                                    withAnimation {
//                                        isModalVisible = false
//                                        selectedTripId = nil
//                                        resetMapRegion()
//                                    }
//                                }) {
//                                    Text("Close")
//                                        .font(.system(size: 16))
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            .padding(10)
//                            .background(Color.blue.opacity(0.8))
//                            
//                            if trips.isEmpty {
//                                Text("No trips available")
//                                    .font(.system(size: 16))
//                                    .foregroundColor(.white)
//                                    .padding()
//                            } else {
//                                ScrollView(.horizontal, showsIndicators: true) {
//                                    HStack(spacing: 15) {
//                                        ForEach(trips) { trip in
//                                            TripCardView(
//                                                trip: trip,
//                                                isAccepted: acceptedTripIds.contains(trip.id),
//                                                onAccept: { handleAcceptTrip(tripId: trip.id) },
//                                                onDecline: { handleDeclineTrip(tripId: trip.id) }
//                                            )
//                                            .frame(width: UIScreen.main.bounds.width - 30)
//                                            .onTapGesture {
//                                                handleTripSelect(trip: trip)
//                                            }
//                                        }
//                                    }
//                                    .padding(.horizontal, 15)
//                                }
//                            }
//                        }
//                        .background(Color.blue.opacity(0.8))
//                        .goCornerRadius(20, corners: [.topLeft, .topRight])
//                        .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
//                        .offset(y: bottomSheetOffset)
//                        .animation(.easeInOut(duration: 0.3), value: isModalVisible)
//                    }
//                    .onChange(of: isModalVisible) { newValue in
//                        withAnimation {
//                            bottomSheetOffset = newValue ? 0 : UIScreen.main.bounds.height
//                        }
//                    }
//                }
//                
//                // Main Button
//                if !buttonText.isEmpty {
//                    Button(action: {
//                        if isOnline {
//                            handleGoOffline()
//                        } else {
//                            handleDriveReady()
//                        }
//                    }) {
//                        Text(buttonText)
//                            .font(.system(size: 20))
//                            .foregroundColor(.white)
//                            .padding(.vertical, 20)
//                            .padding(.horizontal, 40)
//                            .frame(width: UIScreen.main.bounds.width * 0.9)
//                            .background(isOnline ? Color.blue.opacity(0.5) : Color.blue)
//                            .cornerRadius(12)
//                            .shadow(radius: 6)
//                            .scaleEffect(buttonScale)
//                    }
//                    .simultaneousGesture(
//                        DragGesture(minimumDistance: 0)
//                            .onChanged { _ in
//                                withAnimation(.easeInOut(duration: 0.4)) {
//                                    rippleScale = 1.6
//                                }
//                            }
//                            .onEnded { _ in
//                                withAnimation(.easeInOut(duration: 0.2)) {
//                                    rippleScale = 0
//                                }
//                            }
//                    )
//                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100 * scaleFactor)
//                }
//                
//                // Toast
//                if !toastMessage.isEmpty {
//                    Text(toastMessage)
//                        .font(.system(size: 18))
//                        .foregroundColor(.white)
//                        .padding(.vertical, 12)
//                        .padding(.horizontal, 24)
//                        .background(Color.black.opacity(0.85))
//                        .cornerRadius(20)
//                        .opacity(toastOpacity)
//                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200 * scaleFactor)
//                        .animation(.easeInOut(duration: 0.3), value: toastOpacity)
//                }
//                
//                // Footer
//                HStack {
//                    Button(action: {
//                        safetyModalVisible = true
//                    }) {
//                        Text("🛡️")
//                            .font(.system(size: 20))
//                    }
//                    Spacer()
//                    Text(isOnline ? "You're Online" : "You're Offline")
//                        .font(.system(size: 18))
//                        .foregroundColor(.black)
//                    Spacer()
//                    Button(action: {
//                        print("Menu icon tapped")
//                    }) {
//                        Text("⋮")
//                            .font(.system(size: 20))
//                    }
//                }
//                .padding(.vertical, 12)
//                .padding(.horizontal, 15)
//                .background(Color.white.opacity(0.95))
//                .cornerRadius(12)
//                .shadow(radius: 6)
//                .padding(.horizontal, 10)
//                .padding(.bottom, 20)
//            }
//            .opacity(opacity)
//            .animation(.easeInOut(duration: 0.5), value: opacity)
//            .sheet(isPresented: $safetyModalVisible) {
//                SafetyModal(onOptionSelect: { option in
//                    handleSafetyOption(option: option)
//                }, onClose: {
//                    safetyModalVisible = false
//                })
//            }
//            .onAppear {
//                initialize()
//                print("🟢 GoView appeared")
//            }
//            .onDisappear {
//                print("🔴 GoView disappeared")
//            }
//            .onChange(of: isOnline) { _ in
//                fetchTrips()
//            }
//        }
//    }
//    
//    // Map annotations
//    private var annotations: [GoMapAnnotationItem] {
//        var annotations: [GoMapAnnotationItem] = []
//        
//        if let location = currentLocation {
//            annotations.append(GoMapAnnotationItem(
//                coordinate: location,
//                view: AnyView(
//                    Image("car")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 40, height: 40)
//                )
//            ))
//        }
//        
//        if let tripId = selectedTripId, let trip = trips.first(where: { $0.id == tripId }) {
//            annotations.append(GoMapAnnotationItem(
//                coordinate: trip.pickupCoords,
//                view: AnyView(
//                    Image("personlocation")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 40, height: 40)
//                )
//            ))
//            annotations.append(GoMapAnnotationItem(
//                coordinate: trip.dropOffCoords,
//                view: AnyView(
//                    Image("targetflag")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 40, height: 40)
//                )
//            ))
//        }
//        
//        return annotations
//    }
//    
//    // Initialize
//    private func initialize() {
//        let user = fetchUser()
//        isOnline = user.driverProfile?.isOnline ?? false
//        buttonText = isOnline ? "Go Offline" : "Start Driving"
//        buttonColor = isOnline ? .blue : .red
//        print("Initial state: isOnline: \(isOnline), trips: \(trips.count)")
//        
//        locationManager.requestPermissions()
//        if locationManager.authorizationStatus != .authorizedWhenInUse && locationManager.authorizationStatus != .authorizedAlways {
//            print("Location permission denied")
//            showToast("Location permission denied, using default position")
//            currentLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
//            addDebugLog("Location Permission", data: ["status": "denied"])
//            return
//        }
//        
//        if let location = locationManager.getLastKnownLocation() ?? locationManager.getCurrentLocation() {
//            currentLocation = location
//            region = MKCoordinateRegion(
//                center: location,
//                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            )
//            addDebugLog("Initial Location", data: ["latitude": location.latitude, "longitude": location.longitude])
//        } else {
//            print("Failed to fetch location")
//            showToast("Failed to fetch location, using default position")
//            currentLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
//            addDebugLog("Initialization Error", data: ["message": "Failed to fetch location"])
//        }
//        
//        locationManager.onLocationUpdate = { newLocation in
//            currentLocation = newLocation
//            addDebugLog("Location Updated", data: ["latitude": newLocation.latitude, "longitude": newLocation.longitude])
//        }
//        
//        withAnimation(.easeInOut(duration: 0.5)) {
//            opacity = 1
//        }
//        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
//            buttonScale = 1.03
//        }
//        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
//            glowOpacity = 0.5
//        }
//    }
//    
//    // Fetch trips
//    private func fetchTrips() {
//        let tripsData = getTrips()
//        let filteredTrips = tripsData.filter { trip in
//            !declinedTripIds.contains(trip.id)
//        }
//        trips = filteredTrips
//        if !filteredTrips.isEmpty && isOnline {
//            selectedTripId = filteredTrips.first?.id
//            updateMapMarkers(trip: filteredTrips.first)
//        } else {
//            isModalVisible = false
//            selectedTripId = nil
//            resetMapRegion()
//        }
//    }
//    
//    // Fetch route (synchronous)
//    private func fetchRoute() {
//        guard let tripId = selectedTripId, let trip = trips.first(where: { $0.id == tripId }) else {
//            print("⚠️ No valid trip or coordinates for route")
//            routeCoords = []
//            return
//        }
//        
//        let start = currentLocation ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
//        let pickup = trip.pickupCoords
//        let dropoff = trip.dropOffCoords
//        
//        print("Fetching route with coordinates: start: \(start), pickup: \(pickup), dropoff: \(dropoff)")
//        let coords = getRouteCoordinates(start: start, pickup: pickup, dropoff: dropoff)
//        routeCoords = coords
//    }
//    
//    // Update map markers
//    private func updateMapMarkers(trip: Trip?) {
//        guard let trip = trip, !routeCoords.isEmpty else {
//            print("⚠️ Cannot update map, missing coords or route")
//            resetMapRegion()
//            return
//        }
//        
//        let allCoords = [currentLocation ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), trip.pickupCoords, trip.dropOffCoords] + routeCoords
//        let bounds = allCoords.reduce((minLat: Double.infinity, maxLat: -Double.infinity, minLng: Double.infinity, maxLng: -Double.infinity)) { result, coord in
//            (
//                minLat: min(result.minLat, coord.latitude),
//                maxLat: max(result.maxLat, coord.latitude),
//                minLng: min(result.minLng, coord.longitude),
//                maxLng: max(result.maxLng, coord.longitude)
//            )
//        }
//        
//        let center = CLLocationCoordinate2D(
//            latitude: (bounds.minLat + bounds.maxLat) / 2,
//            longitude: (bounds.minLng + bounds.maxLng) / 2
//        )
//        let span = MKCoordinateSpan(
//            latitudeDelta: (bounds.maxLat - bounds.minLat) * 1.2,
//            longitudeDelta: (bounds.maxLng - bounds.minLng) * 1.2
//        )
//        
//        withAnimation {
//            region = MKCoordinateRegion(center: center, span: span)
//        }
//    }
//    
//    // Reset map region
//    private func resetMapRegion() {
//        if let location = currentLocation {
//            withAnimation {
//                region = MKCoordinateRegion(
//                    center: location,
//                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                )
//            }
//        }
//    }
//    
//    // Show toast
//    private func showToast(_ message: String) {
//        toastMessage = message
//        withAnimation(.easeInOut(duration: 0.3)) {
//            toastOpacity = 1
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                toastOpacity = 0
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                toastMessage = ""
//            }
//        }
//    }
//    
//    // Handle drive ready
//    private func handleDriveReady() {
//        patchUserG(isOnline: true)
//        isOnline = true
//        buttonText = "Go Offline"
//        buttonColor = .blue
//        showToast("Now Online")
//        print("Start Driving: User is now online")
//        fetchTrips()
//    }
//    
//    // Handle go offline
//    private func handleGoOffline() {
//        patchUserG(isOnline: false)
//        isOnline = false
//        buttonText = "Start Driving"
//        buttonColor = .red
//        showToast("Now Offline")
//        print("Go Offline: User is now offline")
//        trips = []
//        isModalVisible = false
//        selectedTripId = nil
//        resetMapRegion()
//    }
//    
//    // Handle accept trip
//    private func handleAcceptTrip(tripId: String) {
//        guard let trip = trips.first(where: { $0.id == tripId }) else {
//            print("Trip with ID \(tripId) not found")
//            return
//        }
//        
//        acceptedTripIds.append(tripId)
//        showToast("Trip Accepted!")
//        print("Accepted trip: \(tripId)")
//        let remainingTrips = trips.filter { $0.id != tripId }
//        trips = remainingTrips
//        if remainingTrips.isEmpty {
//            isModalVisible = false
//            selectedTripId = nil
//            resetMapRegion()
//        } else {
//            selectedTripId = remainingTrips.first?.id
//            updateMapMarkers(trip: remainingTrips.first)
//        }
//        print("After accept trip: trips: \(remainingTrips.count), isModalVisible: \(isModalVisible)")
//        
//        print("Navigating to V_Arrived with trip: \(tripId)")
//    }
//    
//    // Handle decline trip
//    private func handleDeclineTrip(tripId: String) {
//        showToast("Trip Declined")
//        declinedTripIds.append(tripId)
//        print("Declined trip: \(tripId)")
//        let remainingTrips = trips.filter { $0.id != tripId }
//        trips = remainingTrips
//        if remainingTrips.isEmpty {
//            isModalVisible = false
//            selectedTripId = nil
//            resetMapRegion()
//        } else {
//            selectedTripId = remainingTrips.first?.id
//            updateMapMarkers(trip: remainingTrips.first)
//        }
//        print("After decline trip: trips: \(remainingTrips.count), isModalVisible: \(isModalVisible)")
//    }
//    
//    // Handle trip select
//    private func handleTripSelect(trip: Trip) {
//        selectedTripId = trip.id
//        fetchRoute()
//        updateMapMarkers(trip: trip)
//        print("Trip selected: \(trip.id)")
//    }
//    
//    // Handle safety option
//    private func handleSafetyOption(option: String) {
//        print("Safety option selected: \(option)")
//        safetyModalVisible = false
//        if option == "View Safety Info" {
//            print("Navigating to HelpSafety")
//        } else if option == "Emergency Contact" {
//            showToast("Contacting emergency services...")
//        }
//    }
//    
//    // Add debug log
//    private func addDebugLog(_ message: String, data: [String: Any] = [:]) {
//        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
//        let log = "[\(timestamp)] \(message): \(data)"
//        debugLogs.append(log)
//        if debugLogs.count > 10 {
//            debugLogs.removeFirst()
//        }
//    }
//}
//
//// Location Manager
//class GoLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
//    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//    }
//    
//    func requestPermissions() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//    
//    func getCurrentLocation() -> CLLocationCoordinate2D? {
//        guard let location = locationManager.location else {
//            return nil
//        }
//        return location.coordinate
//    }
//    
//    func getLastKnownLocation() -> CLLocationCoordinate2D? {
//        locationManager.location?.coordinate
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last?.coordinate {
//            onLocationUpdate?(location)
//        }
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
//    }
//}
//
//// Map Annotation Item
//struct GoMapAnnotationItem: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//    let view: AnyView
//}
//
//// Trip Card View
//struct TripCardView: View {
//    let trip: Trip
//    let isAccepted: Bool
//    let onAccept: () -> Void
//    let onDecline: () -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(trip.from ?? "Unknown Pickup")
//                        .font(.system(size: 14, weight: .bold))
//                        .foregroundColor(.white)
//                    Text("To: \(trip.to ?? "Unknown Drop-off")")
//                        .font(.system(size: 12))
//                        .foregroundColor(.gray)
//                    Text("\(trip.distance ?? "N/A") • \(trip.estimatedTime ?? "N/A")")
//                        .font(.system(size: 12))
//                        .foregroundColor(.gray)
//                    Text("Rider: \(trip.riderName ?? "Unknown")")
//                        .font(.system(size: 12))
//                        .foregroundColor(.gray)
//                }
//                Spacer()
//                Text("$\(String(format: "%.2f", trip.price ?? 0.0))")
//                    .font(.system(size: 16, weight: .bold))
//                    .foregroundColor(.cyan)
//                    .padding(6)
//                    .background(Color.blue.opacity(0.2))
//                    .cornerRadius(8)
//            }
//            if !isAccepted {
//                HStack {
//                    Button(action: onAccept) {
//                        Text("Accept")
//                            .font(.system(size: 14, weight: .bold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                            .background(Color.green)
//                            .cornerRadius(8)
//                    }
//                    Button(action: onDecline) {
//                        Text("Decline")
//                            .font(.system(size: 14, weight: .bold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                            .background(Color.red)
//                            .cornerRadius(8)
//                    }
//                }
//                .padding(.top, 8)
//            }
//        }
//        .padding(10)
//        .background(Color.blue.opacity(0.8))
//        .cornerRadius(12)
//    }
//}
//
//// Safety Modal
//struct SafetyModal: View {
//    let onOptionSelect: (String) -> Void
//    let onClose: () -> Void
//    
//    var body: some View {
//        VStack {
//            Text("Safety Options")
//                .font(.headline)
//            Button("View Safety Info") {
//                onOptionSelect("View Safety Info")
//            }
//            Button("Emergency Contact") {
//                onOptionSelect("Emergency Contact")
//            }
//            Button("Close") {
//                onClose()
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//    }
//}
//
//// Rounded Corners Extension
//struct GoRoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//    
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        return Path(path.cgPath)
//    }
//}
//
//extension View {
//    func goCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(GoRoundedCorner(radius: radius, corners: corners))
//    }
//}
//
//struct GoView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoView()
//    }
//}
