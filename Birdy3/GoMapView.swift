import SwiftUI
import MapKit
import Foundation

// Define MapPoint at the top level
struct MapPoint: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let type: String // "from" or "to" to differentiate markers

    init(coordinate: CLLocationCoordinate2D, type: String) {
        self.coordinate = coordinate
        self.type = type
    }
}

struct Trip: Identifiable, Decodable, Equatable {
    let id: String
    let from: String
    let to: String
    let price: String
    let fromCoords: Coord?
    let toCoords: Coord?
    let promo: Int?
    let rideType: String?
    let time: String?

    struct Coord: Decodable, Equatable {
        let coordinates: [Double]
        let type: String
        
        static func == (lhs: Coord, rhs: Coord) -> Bool {
            lhs.coordinates == rhs.coordinates && lhs.type == rhs.type
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case from, to, price, fromCoords, toCoords, promo, rideType, time
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
        
        if let priceString = try? container.decode(String.self, forKey: .price) {
            price = priceString
        } else if let priceDouble = try? container.decode(Double.self, forKey: .price) {
            price = String(format: "%.2f", priceDouble)
        } else {
            price = "0.00"
        }
        
        if let promoInt = try? container.decode(Int.self, forKey: .promo) {
            promo = promoInt
        } else if let promoString = try? container.decode(String.self, forKey: .promo) {
            promo = Int(promoString)
        } else {
            promo = nil
        }
        
        fromCoords = try? container.decode(Coord.self, forKey: .fromCoords)
        toCoords = try? container.decode(Coord.self, forKey: .toCoords)
        rideType = try? container.decode(String.self, forKey: .rideType)
        time = try? container.decode(String.self, forKey: .time)
    }
    
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }
}

// Custom triangle shape for the button
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// Swipeable Card View
struct SwipeableCardView: View {
    let trip: Trip
    let onSwipeComplete: () -> Void

    
    @State private var offset = CGSize.zero
    @State private var opacity = 1.0
    @State private var rotation = 0.0
    // var onClose: () -> Void
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(radius: 8)
            
            VStack(spacing: 12) {

                HStack {
            Spacer()
            Button(action: {
                // Close action
                print("Close tapped")
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
            }
        }
        .padding([.top, .trailing], 12)

        
                Text("From: \(trip.from)")
                    .font(.custom("Nunito-Regular", size: 18))
                    .foregroundColor(.black)
                
                Text("To: \(trip.to)")
                    .font(.custom("Nunito-Regular", size: 16))
                    .foregroundColor(.gray)
                
                Text("Price: $\(trip.price)")
                    .font(.custom("Nunito-SemiBold", size: 22))
                    .foregroundColor(.blue)
                
                Spacer()
                

                NavigationLink(destination: VArrived(trip: TripParameters(
                        tripId: trip.id,
                        to: trip.to,
                        from: trip.from,
                        distance: nil,
                        price: Double(trip.price) ?? 0.0,
                        toCoords: trip.toCoords.map { TripParameters.Coordinates(latitude: $0.coordinates[1], longitude: $0.coordinates[0]) },
                        fromCoords: trip.fromCoords.map { TripParameters.Coordinates(latitude: $0.coordinates[1], longitude: $0.coordinates[0]) },
                        estimatedTime: nil,
                        riderName: nil
                    ))) {
                        Text("Accept")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.green, .blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(radius: 3)
                    }

                .buttonStyle(PlainButtonStyle()) // preserves your custom button style
                .padding(.bottom, 16)
            }
            .padding()
        }
        .frame(width: 300, height: 300)
        .offset(offset)
        .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    rotation = Double(gesture.translation.width / 25)
                    opacity = Double(1 - abs(gesture.translation.width) / 500)
                }
                .onEnded { _ in
                    withAnimation(.spring()) {
                        if abs(offset.width) > 150 {
                            offset.width = offset.width > 0 ? 1000 : -1000
                            opacity = 0
                            onSwipeComplete()
                        } else {
                            offset = .zero
                            rotation = 0
                            opacity = 1
                        }
                    }
                }
        )
        .onChange(of: trip.id) { _ in
            offset = .zero
            opacity = 1.0
            rotation = 0.0
        }
        .onAppear {
            print("SwipeableCardView appeared for trip: \(trip.id)")
        }
    }
}


 




// MARK: - Map Content View
struct MapContentView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var routePolyline: MKPolyline?
    let mapPoints: [MapPoint]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update region
        uiView.setRegion(region, animated: true)
        
        // Remove existing annotations and overlays
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        
        // Add annotations
        for point in mapPoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = point.coordinate
            annotation.title = point.type
            uiView.addAnnotation(annotation)
        }
        
        // Add polyline
        if let polyline = routePolyline {
            uiView.addOverlay(polyline)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapContentView
        
        init(_ parent: MapContentView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }
            
            let identifier = "MapPoint"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                let imageName = annotation.title == "from" ? "personlocation" : "targetflag"
                if let image = UIImage(named: imageName) {
                    let resizedImage = image.resize(to: CGSize(width: 30, height: 30))
                    annotationView?.image = resizedImage
                }
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

// Extension to resize UIImage
extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}

// MARK: - Trip Cards View
struct TripCardsView: View {
    let trips: [Trip]
    let isLoadingTrips: Bool
    let currentTripIndex: Int
    let refreshTrigger: UUID
    let onSwipe: () -> Void
    
    var body: some View {
        VStack {
                Spacer()
                VStack {
                    Group {
                        if isLoadingTrips {
                            VStack {
                                ProgressView()
                                Text("Loading trips...")
                                    .font(.custom("Nunito-Regular", size: 14))
                                    .foregroundColor(.gray)
                            }
                        } else if trips.isEmpty {
                            Text("No trips available!")
                                .font(.title2)
                                .foregroundColor(.gray)
                        } else if currentTripIndex < trips.count {
                            SwipeableCardView(trip: trips[currentTripIndex]) {
                                withAnimation {
                                    onSwipe()
                                }
                            }
                            .id(trips[currentTripIndex].id)
                        } else {
                            Text("No more trips!")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    .zIndex(1)
                    .frame(width: 300, height: 300)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
              .zIndex(1)
            .id(refreshTrigger)
    }
}

// MARK: - Bottom Toolbar View
struct BottomToolbarView: View {
    let isOnline: Bool
    let buttonOpacity: Double
    let tripsCount: Int
    let onTripsToggle: () -> Void
    let onOnlineToggle: () -> Void
    let onHomeTap: () -> Void
    let onSettingsTap: () -> Void
    
    var body: some View {
        VStack {
            // Trips button
            Button(action: onTripsToggle) {
                Text("\(tripsCount) Trips")
                    .font(.custom("Nunito-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
            }
            .shadow(color: tripsCount > 0 ? .yellow : .clear, radius: tripsCount > 0 ? 5 : 0)
            .padding(.bottom, 10)
            .zIndex(0)
            
            // Toggle button
            Button(action: onOnlineToggle) {
                Text(isOnline ? "Go Offline" : "Go Online")
                    .font(.custom("Nunito-SemiBold", size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isOnline ? Color.red : Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .opacity(buttonOpacity)
            .padding(.bottom, 10)
            .zIndex(0)
            
            // Bottom toolbar
            HStack {
                Button(action: onHomeTap) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(isOnline ? "You're Online" : "Offline")
                    .font(.custom("Nunito-SemiBold", size: 18))
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                
                Spacer()
                
                Button(action: onSettingsTap) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.white)
            .cornerRadius(0)
            .padding(.bottom, 5)
            .zIndex(0)
        }
    }
}



// Updated GoMapView
struct GoMapView: View {
// test start
    // let trip: TripParameters = TripParameters(
    let trip = TripParameters(        
        tripId: "123",
        to: "Destination",
        from: "5167 Lambert Dr, Temple Hills, MD",
        distance: 5.0,
        price: 10.0,
        toCoords: .init(latitude: 38.8205, longitude: -76.9573),
        fromCoords: .init(latitude: 38.8205, longitude: -76.9573),
        estimatedTime: 15.0,
        riderName: "John Doe"
    )
    // test end

    @StateObject private var userLocationManager = UserLocationManager()
    @State private var routePolyline: MKPolyline?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var isOnline = false
    @State private var trips: [Trip] = []
    @State private var isLoadingTrips = true
    @State private var showTrips = false
    @State private var currentTripIndex = 0
    @State private var refreshTrigger = UUID()
    @State private var buttonOpacity = 1.0
    @State private var showHomeSheet = false
    @State private var showSettingsSheet = false
    @State private var isInitialLocationSet = false
    
    var currentMapPoints: [MapPoint] {
        if currentTripIndex < trips.count {
            var points: [MapPoint] = []
            if let fromCoord = trips[currentTripIndex].fromCoords {
                points.append(MapPoint(coordinate: fromCoord.coordinates.toCLLocationCoordinate2D(), type: "from"))
            }
            if let toCoord = trips[currentTripIndex].toCoords {
                points.append(MapPoint(coordinate: toCoord.coordinates.toCLLocationCoordinate2D(), type: "to"))
            }
            return points
        }
        return []
    }
    
     // Add these new structs above GoMapView struct
struct MapBackgroundView: View {
    var body: some View {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
    }
}

struct MapOverlayView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var routePolyline: MKPolyline?
    let mapPoints: [MapPoint]
    
    var body: some View {
        MapContentView(
            region: $region,
            routePolyline: $routePolyline,
            mapPoints: mapPoints
        )
        // .offset(y: -150)  // but shows grey area at bottom. jay fix this 
    }
}

struct NavigationButtonView: View {
    var body: some View {
        HStack {
            Spacer()
            NavigationLink(destination: AddClient()) {
                Image(systemName: "person.badge.plus")
                    .font(.custom("Nunito-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(radius: 3)
                    .padding(.top, 10)
                    .padding(.trailing, 20)
            }
        }
    }
}

// Replace GoMapView body
var body: some View {
    GeometryReader { geometry in
        ZStack {
            MapBackgroundView()
            
            MapOverlayView(
                region: $region,
                routePolyline: $routePolyline,
                mapPoints: currentMapPoints
            )
            
            if showTrips {
                TripCardsView(
                    trips: trips,
                    isLoadingTrips: isLoadingTrips,
                    currentTripIndex: currentTripIndex,
                    refreshTrigger: refreshTrigger,
                    onSwipe: {
                        currentTripIndex += 1
                        print("Card swiped: currentTripIndex = \(currentTripIndex), trips.count = \(trips.count)")
                    }
                )
            }
            
  VStack {
    HStack {
       NavigationLink(destination: HomeView()) {
            Image(systemName: "house.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(10)
                .background(
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple, .pink]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        Color.white.opacity(0.2)
                            .blur(radius: 4)
                    }
                )
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.8), .clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: .black.opacity(0.4), radius: 8, x: 3, y: 3)
                .padding(.leading, 20)
                .padding(.top, 10)
        }
        Spacer()
        NavigationButtonView()
    }
    Spacer()
}



VStack {
    Spacer()
    BottomToolbarView(
        isOnline: isOnline,
        buttonOpacity: buttonOpacity,
        tripsCount: trips.count,
        onTripsToggle: {
            showTrips.toggle()
            refreshTrigger = UUID()
            print("Trips button toggled: showTrips = \(showTrips), trips.count = \(trips.count), isLoadingTrips = \(isLoadingTrips), currentTripIndex = \(currentTripIndex)")
        },
        onOnlineToggle: {
            isOnline.toggle()
            print("Online/Offline toggled: isOnline = \(isOnline)")
            if isOnline {
                withAnimation(.easeInOut(duration: 2)) {
                    buttonOpacity = 0.0
                }
            } else {
                buttonOpacity = 1.0
            }
        },
        onHomeTap: { showHomeSheet = true },
        onSettingsTap: { showSettingsSheet = true }
    )
    .padding(.bottom, 0)
}
.ignoresSafeArea(.all, edges: .bottom)


        }
        .sheet(isPresented: $showHomeSheet) {
            HomeSheetView()
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheetView()
        }
        .onAppear {
            Task {
                await fetchTrips()
            }
        }
        .onChange(of: userLocationManager.userLocation) { newLocation in
            if let location = newLocation, !isInitialLocationSet, !showTrips || trips.isEmpty {
                withAnimation {
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                    print("Initial region set to user location: (\(location.coordinate.latitude), \(location.coordinate.longitude))")
                }
                isInitialLocationSet = true
            }
        }
        .onChange(of: showTrips) { newValue in
            if !newValue {
                currentTripIndex = 0
                routePolyline = nil
                refreshTrigger = UUID()
                print("showTrips set to: \(newValue), currentTripIndex reset to \(currentTripIndex)")
            } else {
                print("showTrips set to: \(newValue), rendering cards with trips.count = \(trips.count), isLoadingTrips = \(isLoadingTrips)")
            }
        }
        .onChange(of: isLoadingTrips) { newValue in
            print("isLoadingTrips changed: \(newValue)")
            refreshTrigger = UUID()
        }
        .onChange(of: trips) { newValue in
            print("Trips updated: count = \(newValue.count)")
            refreshTrigger = UUID()
        }
        .onChange(of: currentTripIndex) { newIndex in
            print("onChange currentTripIndex: \(newIndex)")
            if newIndex < trips.count, let fromCoord = trips[newIndex].fromCoords, let toCoord = trips[newIndex].toCoords {
                let from = fromCoord.coordinates.toCLLocationCoordinate2D()
                let to = toCoord.coordinates.toCLLocationCoordinate2D()
                let center = CLLocationCoordinate2D(latitude: (from.latitude + to.latitude) / 2, longitude: (from.longitude + to.longitude) / 2)
                let maxLatDelta = max(abs(from.latitude - to.latitude), 0.01)
                let maxLonDelta = max(abs(from.longitude - to.longitude), 0.01)
                withAnimation {
                    region = MKCoordinateRegion(
                        center: center,
                        span: MKCoordinateSpan(latitudeDelta: maxLatDelta * 1.5, longitudeDelta: maxLonDelta * 1.5)
                    )
                    print("Region set for trip \(newIndex): center=(\(center.latitude), \(center.longitude)), delta=(\(maxLatDelta * 1.5), \(maxLonDelta * 1.5))")
                }
                Task {
                    print("Triggering fetchRoutes for trip index \(newIndex)")
                    await fetchRoutes()
                }
            } else {
                withAnimation {
                    routePolyline = nil
                    region = MKCoordinateRegion(
                        center: userLocationManager.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                    print("Region reset to default or user location due to invalid trip index")
                }
            }
            refreshTrigger = UUID()
        }
    }
}
    
    private func fetchTrips() async {
        print("Fetching trips...")
        do {
            var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)trips/getTrips")!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = try? await KeychainHelper.getToken() {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let errorData = try JSONDecoder().decode(ErrorResponse.self, from: data)
                print("Error fetching trips: \(errorData.error ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.trips = []
                    self.isLoadingTrips = false
                }
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            } else {
                print("Failed to convert data to string")
            }
            
            do {
                let trips = try JSONDecoder().decode([Trip].self, from: data)
                DispatchQueue.main.async {
                    self.trips = trips
                    self.isLoadingTrips = false
                    print("Trips loaded: count = \(trips.count)")
                }
            } catch {
                print("Failed to decode as array: \(error.localizedDescription)")
                struct WrappedResponse: Decodable {
                    let trips: [Trip]
                }
                do {
                    let wrapped = try JSONDecoder().decode(WrappedResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.trips = wrapped.trips
                        self.isLoadingTrips = false
                        print("Trips loaded from wrapped response: count = \(wrapped.trips.count)")
                    }
                } catch {
                    print("Failed to decode as wrapped object: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.trips = []
                        self.isLoadingTrips = false
                    }
                }
            }
            
        } catch {
            print("Failed to fetch trips: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.trips = []
                self.isLoadingTrips = false
            }
        }
    }
    
    private func fetchRoutes() async {
        print("🚀 Starting fetchRoutes for trip index \(currentTripIndex)")
        guard currentTripIndex < trips.count,
              let fromCoord = trips[currentTripIndex].fromCoords,
              let toCoord = trips[currentTripIndex].toCoords,
              let userLocation = userLocationManager.userLocation else {
            print("⚠️ No valid trip, coordinates, or user location for route")
            DispatchQueue.main.async {
                self.routePolyline = nil
            }
            return
        }
        
        let start = ["latitude": userLocation.coordinate.latitude, "longitude": userLocation.coordinate.longitude]
        let pickup = ["latitude": fromCoord.coordinates[1], "longitude": fromCoord.coordinates[0]]
        let dropoff = ["latitude": toCoord.coordinates[1], "longitude": toCoord.coordinates[0]]
        
        print("🛠️ Fetching route for trip \(trips[currentTripIndex].id) with coordinates: start=\(start), pickup=\(pickup), dropoff=\(dropoff)")
        
        var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)api/route")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = try? await KeychainHelper.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = ["start": start, "pickup": pickup, "dropoff": dropoff]
        guard let requestBody = try? JSONSerialization.data(withJSONObject: body) else {
            print("❌ Failed to serialize request body")
            DispatchQueue.main.async {
                self.routePolyline = nil
            }
            return
        }
        request.httpBody = requestBody
        
        var data: Data?
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            data = responseData
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let errorData = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                print("❌ Error fetching route: \(errorData.error ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.routePolyline = nil
                }
                return
            }
            
            if let jsonString = String(data: responseData, encoding: .utf8) {
                print("✅ Route response for trip \(trips[currentTripIndex].id): \(jsonString)")
            } else {
                print("❌ Failed to convert response data to string")
            }
            
            struct RouteResponse: Decodable {
                struct Coordinate: Decodable {
                    let latitude: Double
                    let longitude: Double
                }
                let coordinates: [Coordinate]
            }
            
            let routeResponse = try JSONDecoder().decode(RouteResponse.self, from: responseData)
            let coordinates = routeResponse.coordinates
                .filter { coord in
                    let isValid = coord.latitude >= -90 && coord.latitude <= 90 &&
                                  coord.longitude >= -180 && coord.longitude <= 180
                    if !isValid {
                        print("⚠️ Filtered invalid coordinate for trip \(trips[currentTripIndex].id): latitude=\(coord.latitude), longitude=\(coord.longitude)")
                    }
                    return isValid
                }
                .map { coord in
                    CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
                }
            guard !coordinates.isEmpty else {
                print("❌ No valid coordinates in response for trip \(trips[currentTripIndex].id)")
                DispatchQueue.main.async {
                    self.routePolyline = nil
                }
                return
            }
            
            DispatchQueue.main.async {
                self.routePolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                // Adjust region to fit polyline
                let latitudes = coordinates.map { $0.latitude }
                let longitudes = coordinates.map { $0.longitude }
                let minLat = latitudes.min() ?? 37.7749
                let maxLat = latitudes.max() ?? 37.7749
                let minLon = longitudes.min() ?? -122.4194
                let maxLon = longitudes.max() ?? -122.4194
                let centerLat = (minLat + maxLat) / 2
                let centerLon = (minLon + maxLon) / 2
                let latDelta = max((maxLat - minLat) * 1.5, 0.01)
                let lonDelta = max((maxLon - minLon) * 1.5, 0.01)
                self.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                    span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
                )
                print("🛠️ Route polyline updated for trip \(self.trips[self.currentTripIndex].id) with \(coordinates.count) points, region centered at (\(centerLat), \(centerLon))")
            }
        } catch {
            print("❌ Failed to fetch route for trip \(trips[currentTripIndex].id): \(error)")
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("❌ Response content: \(jsonString)")
            } else {
                print("❌ Unable to print response content")
            }
            DispatchQueue.main.async {
                self.routePolyline = nil
            }
        }
    }
}

// Placeholder AddClientView
struct AddClientView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            
            Text("Add Client Screen")
                .font(.custom("Nunito-Bold", size: 34))
                .foregroundColor(.primary)
        }
        .navigationTitle("Add Client")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add Client")
                    .font(.custom("Nunito-Bold", size: 20))
                    .foregroundColor(.primary)
            }
        }
    }
}

struct HomeSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Home Sheet")
                .font(.custom("Nunito-Bold", size: 24))
                .foregroundColor(.black)
            Spacer()
            Button("Close") {
                dismiss()
            }
            .font(.custom("Nunito-SemiBold", size: 16))
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.bottom, 10)
    }
}

struct SettingsSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Chevron, Text, and Menu
            ZStack {
                Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)) // Dark green
                    .frame(height: 60)
                
                HStack {
                    // Chevron and Text in one line to Close
                    Button(action: {
                        withAnimation {
                            dismiss()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text("⌃") // Upside-down chevron (^ pointing down)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(180))
                            Text("Some options for you")
                                .font(.custom("Nunito-SemiBold", size: 16))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    // Menu Icon
                    Button(action: {
                        print("Menu tapped")
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .padding(.trailing, 20)
                    }
                }
            }
            
            // Settings options
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Button(action: {
                        print("Earnings tapped")
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundColor(.purple)
                                .imageScale(.large)
                            Text("Earnings")
                                .font(.custom("Nunito-SemiBold", size: 18))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Button(action: {
                        print("See More Promotions tapped")
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "tag.fill")
                                .foregroundColor(.purple)
                                .imageScale(.large)
                            Text("See More Promotions")
                                .font(.custom("Nunito-SemiBold", size: 18))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Button(action: {
                        print("See Driving Time History tapped")
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.purple)
                                .imageScale(.large)
                            Text("See Driving Time History")
                                .font(.custom("Nunito-SemiBold", size: 18))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            // Bottom Toolbar Strip
            HStack {
                // Left Icon
                Button(action: {
                    print("Left icon tapped")
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .padding()
                        .background(Color.purple)
                        .clipShape(Circle())
                }
                .padding(.leading, 20)
                
                Spacer()
                
                // Center Text with Emoji
                Text("🛑 Go Offline")
                    .font(.custom("Nunito-SemiBold", size: 18))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.red)
                    .cornerRadius(10)
                
                Spacer()
                
                // Right Icon
                Button(action: {
                    print("Right icon tapped")
                }) {
                    Image(systemName: "bell")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .padding()
                        .background(Color.purple)
                        .clipShape(Circle())
                }
                .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))) // Matching header color
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
    }
}

extension Array where Element == Double {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        if self.count >= 2 {
            return CLLocationCoordinate2D(latitude: self[1], longitude: self[0])
        }
        return CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Default to San Francisco if invalid
    }
}

struct GoMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GoMapView()
        }
    }
}
