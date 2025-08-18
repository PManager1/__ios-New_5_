//import SwiftUI
//import MapKit
//
//struct RideConfirm: View {
//    @State private var bottomSheetTranslateY: CGFloat = UIScreen.main.bounds.height * 0.15 // Start higher
//    @State private var snapPoints: [CGFloat] = [UIScreen.main.bounds.height * 0.05, UIScreen.main.bounds.height * 0.4]
//    @State private var routeCoords: [Coordinate] = []
//    @State private var paymentMethod: Bool = false
//    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 38.92605, longitude: -77.0658),
//        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//    )
//    
//    // Mock store data (consistent with ChooseRide.swift)
//    @State private var from: String = "5617 Lambert Dr, Cardozo, DC"
//    @State private var to: String = "123 Main St, Arlington, VA"
//    @State private var rideType: String = "Birdy X"
//    @State private var price: Double = 56.17 // Matches Birdy X price in ChooseRide
//    @State private var promo: Double = 7.00 // Matches promo in ChooseRide
//    
//    // Mock coordinates (consistent with ChooseRide.swift)
//    private let driverLocation = Coordinate(latitude: 38.83, longitude: -76.93)
//    private let fromCoords = Coordinate(latitude: 38.9072, longitude: -77.0369)
//    private let toCoords = Coordinate(latitude: 38.8790, longitude: -77.1068)
//    
//    // Map annotations
//    private var annotations: [MapAnnotationItem] {
//        [
//            MapAnnotationItem(id: UUID(), coordinate: driverLocation, title: "Your Location", tint: .black),
//            MapAnnotationItem(id: UUID(), coordinate: fromCoords, title: "Rider Pickup", tint: .green),
//            MapAnnotationItem(id: UUID(), coordinate: toCoords, title: "Drop-off", tint: .red)
//        ]
//    }
//    
//    // Polyline coordinates
//    private var polylineCoordinates: [CLLocationCoordinate2D] {
//        routeCoords.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // Map (at top, Apple Maps style)
//                Map(coordinateRegion: $region, annotationItems: annotations) { item in
//                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude), tint: item.tint)
//                }
//                .ignoresSafeArea()
//                
//                // Bottom Sheet (Card)
//                VStack {
//                    Spacer()
//                    VStack(spacing: 0) {
//                        Rectangle()
//                            .frame(width: 40, height: 5)
//                            .foregroundColor(.gray.opacity(0.7))
//                            .cornerRadius(3)
//                            .padding(.top, 8)
//                            .padding(.bottom, 16)
//                        Text("Confirm Your Ride")
//                            .font(.custom("Nunito-Bold", size: 20))
//                            .foregroundColor(.black)
//                            .padding(.bottom, 16)
//                        // Locations
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Circle()
//                                    .frame(width: 10, height: 10)
//                                    .foregroundColor(.green)
//                                Text(from)
//                                    .font(.custom("Nunito-Regular", size: 16))
//                                    .foregroundColor(.black)
//                            }
//                            HStack {
//                                Circle()
//                                    .frame(width: 10, height: 10)
//                                    .foregroundColor(.red)
//                                Text(to)
//                                    .font(.custom("Nunito-Regular", size: 16))
//                                    .foregroundColor(.black)
//                            }
//                        }
//                        .padding(.bottom, 16)
//                        // Promo
//                        Text("$\(String(format: "%.2f", promo)) PROMO APPLIED")
//                            .font(.custom("Nunito-Bold", size: 16))
//                            .foregroundColor(.green)
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 12)
//                            .background(Color.green.opacity(0.1))
//                            .cornerRadius(8)
//                            .padding(.bottom, 16)
//                        // Ride Details
//                        HStack {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.3))
//                                .frame(width: 80, height: 80)
//                                .cornerRadius(12)
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("\(rideType) • 4 passengers")
//                                    .font(.custom("Nunito-Bold", size: 18))
//                                    .foregroundColor(.black)
//                                Text("ETA: 11 min away")
//                                    .font(.custom("Nunito-Regular", size: 14))
//                                    .foregroundColor(.gray)
//                                Text("Affordable rides, all to yourself")
//                                    .font(.custom("Nunito-Regular", size: 14))
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                            VStack(alignment: .trailing, spacing: 4) {
//                                Text("$\(String(format: "%.2f", price))")
//                                    .font(.custom("Nunito-Bold", size: 18))
//                                    .foregroundColor(.black)
//                                Text("$\(String(format: "%.2f", price + promo))")
//                                    .font(.custom("Nunito-Regular", size: 14))
//                                    .foregroundColor(.gray)
//                                    .strikethrough()
//                            }
//                        }
//                        .padding(.bottom, 16)
//                        // Payment Method
//                        Button(action: {
//                            withAnimation(.easeOut(duration: 0.15)) {
//                                paymentMethod.toggle()
//                                print("Payment method toggled: \(paymentMethod)")
//                            }
//                        }) {
//                            HStack {
//                                Text("Add Payment Method")
//                                    .font(.custom("Nunito-Bold", size: 16))
//                                    .foregroundColor(.black)
//                                Spacer()
//                                Text("You save $\(String(format: "%.2f", promo))")
//                                    .font(.custom("Nunito-Regular", size: 14))
//                                    .foregroundColor(.green)
//                            }
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 16)
//                            .background(Color.gray.opacity(0.05))
//                            .cornerRadius(12)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//                            )
//                        }
//                        .padding(.bottom, 16)
//                        // Confirm Button
//                        Button(action: {
//                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                                if from.isEmpty || to.isEmpty || rideType.isEmpty || price == 0.0 {
//                                    print("Missing required fields: from=\(from), to=\(to), rideType=\(rideType), price=\(price), promo=\(promo)")
//                                } else {
//                                    print("Confirm \(rideType) tapped, creating trip with: from=\(from), to=\(to), rideType=\(rideType), price=\(price), promo=\(promo)")
//                                    createTrip()
//                                }
//                            }
//                        }) {
//                            Text("Confirm \(rideType)")
//                                .font(.custom("Nunito-Bold", size: 18))
//                                .foregroundColor(.white)
//                                .padding(.vertical, 14)
//                                .frame(maxWidth: .infinity)
//                                .background(from.isEmpty || to.isEmpty || rideType.isEmpty ? Color.gray : Color.black)
//                                .cornerRadius(12)
//                        }
//                        .padding(.bottom, 32)
//                    }
//                    .padding(.horizontal, 16)
//                    .background(
//                        ZStack {
//                            Color.white
//                            VisualEffectView(effect: UIBlurEffect(style: .systemMaterialLight))
//                                .opacity(0.8)
//                        }
//                    )
//                    .clipShape(RoundedRectangle(cornerRadius: 24))
//                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: -4)
//                }
//                .offset(y: bottomSheetTranslateY)
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            let newY = max(snapPoints[1], value.translation.height)
//                            bottomSheetTranslateY = newY
//                        }
//                        .onEnded { value in
//                            let midpoint = (snapPoints[0] + snapPoints[1]) / 2
//                            let snapPoint = value.translation.height > midpoint ? snapPoints[1] : snapPoints[0]
//                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                                bottomSheetTranslateY = snapPoint
//                            }
//                        }
//                )
//            }
//            .background(Color(.systemGray6))
//            .navigationTitle("")
//            .navigationBarHidden(false) // Allow system back button
//            .onAppear {
//                getRouteCoordinates(start: driverLocation, pickup: fromCoords, dropoff: toCoords)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    fitMapToCoordinates()
//                }
//            }
//        }
//    }
//    
//    // Placeholder functions
//    private func getRouteCoordinates(start: Coordinate, pickup: Coordinate, dropoff: Coordinate) {
//        print("Mock getRouteCoordinates for: start=\(start), pickup=\(pickup), dropoff=\(dropoff)")
//        routeCoords = [start, pickup, dropoff]
//    }
//    
//    private func createTrip() {
//        print("Mock createTrip with: from=\(from), to=\(to), rideType=\(rideType), price=\(price), promo=\(promo)")
//        print("Navigating to RideWaiting")
//    }
//    
//    private func fitMapToCoordinates() {
//        let allCoords = routeCoords.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
//        if allCoords.count >= 2 {
//            let minLat = allCoords.map { $0.latitude }.min() ?? 38.92605
//            let maxLat = allCoords.map { $0.latitude }.max() ?? 38.92605
//            let minLon = allCoords.map { $0.longitude }.min() ?? -77.0658
//            let maxLon = allCoords.map { $0.longitude }.max() ?? -77.0658
//            let center = CLLocationCoordinate2D(
//                latitude: (minLat + maxLat) / 2,
//                longitude: (minLon + maxLon) / 2
//            )
//            let span = MKCoordinateSpan(
//                latitudeDelta: (maxLat - minLat) * 1.3,
//                longitudeDelta: (maxLon - minLon) * 1.3
//            )
//            region = MKCoordinateRegion(center: center, span: span)
//        }
//    }
//}
//
//// Models
//struct MapAnnotationItem: Identifiable {
//    let id: UUID
//    let coordinate: Coordinate
//    let title: String
//    let tint: Color
//}
//
//// Visual Effect View for Blur
//struct VisualEffectView: UIViewRepresentable {
//    let effect: UIVisualEffect
//    
//    func makeUIView(context: Context) -> UIVisualEffectView {
//        UIVisualEffectView(effect: effect)
//    }
//    
//    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
//        uiView.effect = effect
//    }
//}
//
//struct RideConfirm_Previews: PreviewProvider {
//    static var previews: some View {
//        RideConfirm()
//    }
//}
