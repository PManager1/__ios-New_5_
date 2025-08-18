import SwiftUI
import MapKit

struct TripParameters {
    let tripId: String?
    let to: String?
    let from: String?
    let distance: Double?
    let price: Double?
    let toCoords: Coordinates?
    let fromCoords: Coordinates?
    let estimatedTime: Double?
    let riderName: String?
    
    struct Coordinates {
        let latitude: Double
        let longitude: Double
    }
}


struct VArrived: View {

    let trip: TripParameters // <-- This is the only line you need here.

    @State private var region: MKCoordinateRegion
    @State private var showCancelAlert = false
    @State private var navigateToConfirm = false
    @State private var mapScale: CGFloat = 0.8
    @State private var buttonOpacity: Double = 0
    @State private var swipeGlowOpacity: Double = 0

    // 2. The 'init' method will set the value one time.
    init(trip: TripParameters) {
        self.trip = trip // <-- This is where 'trip' is initialized.



        print("Spit Trip details: \(trip)")

        // Initialize all other properties.
        self._showCancelAlert = State(initialValue: false)
        self._navigateToConfirm = State(initialValue: false)
        self._mapScale = State(initialValue: 0.8)
        self._buttonOpacity = State(initialValue: 0)
        self._swipeGlowOpacity = State(initialValue: 0)

        let defaultRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 38.8205, longitude: -76.9573),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        if let coords = trip.fromCoords,
           coords.latitude.isFinite, coords.longitude.isFinite {
            self._region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        } else {
            self._region = State(initialValue: defaultRegion)
        }
    }
    

    // new end 




    
    // init() {
        // let defaultRegion = MKCoordinateRegion(
        //     center: CLLocationCoordinate2D(latitude: 38.8205, longitude: -76.9573),
        //     span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        // )
        // if let coords = VArrived.staticParameters.fromCoords,
        //    coords.latitude.isFinite, coords.longitude.isFinite {
        //     self._region = State(initialValue: MKCoordinateRegion(
        //         center: CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude),
        //         span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        //     ))
        // } else {
        //     self._region = State(initialValue: defaultRegion)
        // }
    // }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with radial gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#1E3A8A"), Color(hex: "#2DD4BF")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay(
                    RadialGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.1), Color.clear]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                    .blur(radius: 10)
                )
                .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack(spacing: 20) {
                        // Map with buttons overlay
                        ZStack(alignment: .top) {
                            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [MapAnnotationItem(coordinate: .init(latitude: region.center.latitude, longitude: region.center.longitude))]) { item in
                                MapMarker(coordinate: item.coordinate, tint: .red)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.65)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
                            .scaleEffect(mapScale)
                            .padding(.horizontal, 15)
                            .onAppear {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    mapScale = 1.0
                                }
                            }
                            
                            HStack(spacing: 20) {
                                // MapButton(imageName: "Google_Maps", action: handleGoogleMaps)
                                // MapButton(imageName: "AppleMaps", action: handleAppleMaps)
                                // MapButton(imageName: "waze", action: handleWazeMaps)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                            .background(
                                Color.white.opacity(0.2)
                                    .blur(radius: 10)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    )
                            )
                            .opacity(buttonOpacity)
                            .onAppear {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                                    buttonOpacity = 1
                                }
                            }
                        }
                        
                        // Pickup address with divider
                        // VStack(spacing: 8) {
                        //     Text("Pick-up: \(VArrived.staticParameters.from ?? "Unknown Address")")
                        //         .font(.custom("Nunito-Bold", size: 14))
                        //         .foregroundColor(.white)
                        //         .multilineTextAlignment(.center)
                        //         .padding(.horizontal, 20)
                        //         .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                            
                        //     Rectangle()
                        //         .fill(Color.white.opacity(0.3))
                        //         .frame(height: 1)
                        //         .padding(.horizontal, 40)
                        // }
                        
                        // Swipe button
                        SwipeButton(navigate: $navigateToConfirm, glowOpacity: $swipeGlowOpacity)
                            .frame(height: 50)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    swipeGlowOpacity = 0.6
                                }
                            }
                        
                        // Action buttons
                        HStack(spacing: 50) {
                            ActionButton(icon: "xmark.circle.fill", text: "Cancel Ride") {
                                showCancelAlert = true
                            }
                            ActionButton(icon: "phone.fill", text: "Contact") {
                                print("Contact Rider tapped")
                            }
                        }
                        .padding(.horizontal, 20)
                        .opacity(buttonOpacity)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
                                buttonOpacity = 1
                            }
                        }
                        
                        Spacer()
                        
//                        NavigationLink(destination: VConfirmView(), isActive: $navigateToConfirm) {
                            EmptyView()
                        }
                    }
                    .opacity(buttonOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.8)) {
                            buttonOpacity = 1
                        }
                    }
                }
            }
            .alert(isPresented: $showCancelAlert) {
                let waitTime = Date().addingTimeInterval(5 * 60)
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                let formattedTime = formatter.string(from: waitTime)
                
                return Alert(
                    title: Text("Are you sure you want to cancel?"),
                    message: Text("To receive a No Show fee, you must wait for the rider until \(formattedTime). Otherwise, you won't receive a No Show fee."),
                    primaryButton: .destructive(Text("Yes")) {
                        // Handle cancel logic here
                    },
                    secondaryButton: .default(Text("No"))
                )
            }
        }
    }
    
    struct MapButton: View {
        let imageName: String
        let action: () -> Void
        @State private var scale: CGFloat = 1.0
        
        var body: some View {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 0.9
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        scale = 1.0
                    }
                    action()
                }
            }) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .blur(radius: 8)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                    )
                    .clipShape(Circle())
            }
            .scaleEffect(scale)
        }
    }
    
    struct ActionButton: View {
        let icon: String
        let text: String
        let action: () -> Void
        @State private var scale: CGFloat = 1.0
        
        var body: some View {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 0.95
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        scale = 1.0
                    }
                    action()
                }
            }) {
                VStack(spacing: 6) {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 1)
                    Text(text)
                        .font(.custom("Nunito-SemiBold", size: text == "Cancel Ride" ? 18 : 16))
                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                }
                .padding(10)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
//                        .shadow(color: .black.opacity(0.2), radius: 5, x: 3, y: 3)
//                        .shadow(color: .white.opacity(0.1), radius: 5, x: -3, y: -3)
                )
            }
            .scaleEffect(scale)
        }
    }
    
    struct SwipeButton: View {
        @Binding var navigate: Bool
        @Binding var glowOpacity: Double
        @State private var offset: CGFloat = 0
        @State private var isSwiped = false
        private let handleSize: CGFloat = 50
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    Capsule()
                        .fill(LinearGradient(colors: [Color(hex: "#3B82F6"), Color(hex: "#8B5CF6")], startPoint: .leading, endPoint: .trailing))
                        .frame(height: handleSize)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                    
                    // Label
                    Text("Swipe to Arrive")
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .foregroundColor(.white)
                        .padding(.leading, 80)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                    
                    // Handle
                    ZStack {
                        Capsule()
                            .fill(LinearGradient(colors: [.white, Color(hex: "#E0E7FF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: handleSize, height: handleSize)
                            .shadow(color: .black.opacity(glowOpacity), radius: 10, x: 0, y: 0)
                        Image(systemName: "chevron.right.2")
                            .foregroundColor(Color(hex: "#3B82F6"))
                            .font(.system(size: 26, weight: .bold))
                    }
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let maxOffset = geometry.size.width - handleSize
                                offset = min(max(0, value.translation.width), maxOffset)
                                
                                if offset >= maxOffset * 0.85 && !isSwiped {
                                    isSwiped = true
                                    navigate = true
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        glowOpacity = 0.8
                                    }
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.easeOut) {
                                    offset = 0
                                    isSwiped = false
                                    glowOpacity = 0.4
                                }
                            }
                    )
                    // Trail effect
                    Capsule()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: offset, height: handleSize * 0.8)
                        .offset(x: 0)
                        .opacity(offset > 0 ? 0.5 : 0)
                }
                .frame(height: handleSize)
                .padding()
                .background(
                NavigationLink("", destination: VConfirm(), isActive: $navigate)
                    .opacity(0)
            )
            }
        }
    }
    
    struct MapAnnotationItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    struct VConfirmView: View {
        var body: some View {
            Text("VConfirm Screen")
                .font(.custom("Nunito-Bold", size: 28))
                .foregroundColor(.blue)
        }
    }
    
    struct GoView: View {
        var body: some View {
            Text("Go Screen")
                .font(.custom("Nunito-Bold", size: 28))
                .foregroundColor(.blue)
        }
    }
    
    // private func handleGoogleMaps() {
    //     let encodedAddress = (VArrived.staticParameters.from ?? "Unknown Address").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    //     let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(encodedAddress)&travelmode=driving")!
    //     UIApplication.shared.open(url)
    // }
    
    // private func handleAppleMaps() {
    //     let encodedAddress = (VArrived.staticParameters.from ?? "Unknown Address").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    //     let url = URL(string: "http://maps.apple.com/?daddr=\(encodedAddress)")!
    //     UIApplication.shared.open(url)
    // }
    
    // private func handleWazeMaps() {
    //     let encodedAddress = (VArrived.staticParameters.from ?? "Unknown Address").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    //     let url = URL(string: "https://waze.com/ul?q=\(encodedAddress)&navigate=yes")!
    //     UIApplication.shared.open(url)
    // }
// }


// struct VArrived_Previews: PreviewProvider {
//     static var previews: some View {
//         VArrived()
//     }
// }

struct VArrived_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample TripParameters object for the preview
        let sampleTrip = TripParameters(
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
        
        // Pass the sample trip to the VArrived view
        VArrived(trip: sampleTrip)
    }
}