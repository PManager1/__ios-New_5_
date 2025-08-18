import SwiftUI

struct ChooseRide: View {
    @State private var selectedRide: String = "Birdy X"
    @State private var errorMessage: String = ""
    @State private var screen: String = "ride"
    @State private var containerOpacity: CGFloat = 0.0
    @State private var containerTranslateY: CGFloat = 50.0
    @State private var slideX: CGFloat = 0.0
    
    // Mock store data
    @State private var from: String = "5617 Lambert Dr, Cardozo, DC"
    @State private var to: String = "123 Main St, Arlington, VA"
    @State private var stop1: String? = "789 Oak St, Bethesda, MD"
    @State private var stop2: String? = nil
    @State private var price: [String: Double] = [
        "Birdy X": 56.17,
        "Birdy XL": 63.17,
        "Birdy Premium": 59.28,
        "Birdy PremiumXL": 85.85
    ]
    @State private var promo: Double = 7.00
    @State private var distance: Double? = 10.5
    
    // Mock coordinates
    private let driverLocation = Coordinate(latitude: 38.83, longitude: -76.93)
    private let fromCoords = Coordinate(latitude: 38.9072, longitude: -77.0369)
    private let toCoords = Coordinate(latitude: 38.8790, longitude: -77.1068)
    private let stop1Coords = Coordinate(latitude: 38.9897, longitude: -77.0947)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Map Placeholder
                ZStack {
                    Color.gray.opacity(0.3)
                        .frame(height: UIScreen.main.bounds.height * 0.38)
                    VStack {
                        Text("Map Placeholder")
                            .font(.custom("Nunito-Bold", size: 16))
                            .foregroundColor(.white)
                        Text("Driver, Pickup, Stops, Drop-off")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.white)
                    }
                    // Back Button
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.15)) {
                            print("Back button tapped")
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .position(x: 20, y: 40)
                    // Markers
                    Image(systemName: "car.fill")
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .position(x: 100, y: 100)
                    Image(systemName: "person.fill")
                        .foregroundColor(.green)
                        .frame(width: 40, height: 40)
                        .position(x: 150, y: 150)
                    Image(systemName: "flag.fill")
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                        .position(x: 200, y: 200)
                    if stop1 != nil {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.orange)
                            .frame(width: 40, height: 40)
                            .position(x: 175, y: 175)
                    }
                }
                
                // Ride Options Container
                ScrollView {
                    VStack(spacing: 0) {
                        // Ride Selection or Payment Screen
                        withAnimation(.easeInOut(duration: 0.1)) {
                            Group {
                                if screen == "ride" {
                                    RideSelectionScreen()
                                } else {
                                    PaymentMethodScreen()
                                }
                            }
                            .offset(x: slideX)
                        }
                        
                        // Choose Button and Error Message
                        if screen == "ride" {
                            Button(action: {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    if selectedRide.isEmpty {
                                        errorMessage = "Please select a ride type before continuing."
                                    } else {
                                        errorMessage = ""
                                        print("Choose ride: \(selectedRide), price: \(price[selectedRide] ?? 0.0), promo: \(promo), distance: \(distance ?? 0.0)")
                                        print("Navigating to RideConfirm with data: \(rideData)")
                                    }
                                }
                            }) {
                                Text("Choose \(selectedRide.isEmpty ? "a ride" : selectedRide)")
                                    .font(.custom("Nunito-Bold", size: 18))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedRide.isEmpty ? Color.gray : Color.black)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .disabled(selectedRide.isEmpty)
                            
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .font(.custom("Nunito-Regular", size: 14))
                                    .foregroundColor(.red)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -2)
                .offset(y: -20)
                .opacity(containerOpacity)
                .offset(y: containerTranslateY)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.8)) {
                        containerOpacity = 1.0
                        containerTranslateY = 0.0
                    }
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    // Ride Selection Screen
    private func RideSelectionScreen() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Choose a ride")
                .font(.custom("Nunito-ExtraBold", size: 24))
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
            
            // Location List
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.green)
                    Text(from)
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(.black)
                }
                if let stop1 = stop1 {
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.orange)
                        Text(stop1)
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                }
                if let stop2 = stop2 {
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.purple)
                        Text(stop2)
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                }
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.red)
                    Text(to)
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // Demand Notice
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(.blue)
                    .frame(width: 20, height: 20)
                Text("Fares are slightly higher due to increased demand")
                    .font(.custom("Nunito-SemiBold", size: 14))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // Promo
            HStack {
                Image(systemName: "tag")
                    .foregroundColor(.blue)
                    .frame(width: 20, height: 20)
                Text("$7.00 promo applied – ")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(.black)
                +
                Text("Let's price match")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(.blue)
                    .underline()
            }
            .padding(10)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.15)) {
                    print("Navigating to PriceMatch")
                }
            }
            
            // Ride Options
            ForEach(rideOptions) { ride in
                Button(action: {
                    withAnimation(.easeOut(duration: 0.15)) {
                        selectedRide = ride.type
                        errorMessage = ""
                        print("Selected ride: \(ride.type), promo: \(ride.type == "Birdy X" ? 7.0 : 0.0)")
                    }
                }) {
                    HStack {
                        Image(systemName: "car")
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 15)
                        VStack(alignment: .leading) {
                            HStack {
                                Text(ride.type)
                                    .font(.custom("Nunito-Bold", size: 18))
                                    .foregroundColor(.black)
                                HStack {
                                    Image(systemName: "person")
                                        .foregroundColor(.black)
                                    Text("x\(ride.capacity)")
                                        .font(.custom("Nunito-Regular", size: 14))
                                        .foregroundColor(.black)
                                }
                                .padding(.leading, 10)
                                if let tag = ride.tag {
                                    Text(tag)
                                        .font(.custom("Nunito-Bold", size: 12))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                            Text("\(ride.duration)")
                                .font(.custom("Nunito-Light", size: 14))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(price[ride.type] != nil ? "$\(String(format: "%.2f", price[ride.type]!))" : "N/A")
                            .font(.custom("Nunito-ExtraBold", size: 18))
                            .foregroundColor(.blue)
                    }
                    .padding(15)
                    .background(selectedRide == ride.type ? Color.blue.opacity(0.1) : Color.gray.opacity(0.02))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedRide == ride.type ? Color.blue : Color.gray.opacity(0.2), lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                }
            }
            
            // Payment Method Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.1)) {
                    slideX = 10
                    screen = "payment"
                }
            }) {
                HStack {
                    Image(systemName: "creditcard")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                    Text("Add Payment Method")
                        .font(.custom("Nunito-Regular", size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
                .padding(15)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.2))
                        .offset(y: 15)
                )
                .padding(.horizontal, 20)
            }
        }
    }
    
    // Payment Method Screen
    private func PaymentMethodScreen() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        slideX = 0
                        screen = "ride"
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                }
                Text("Add Payment Method")
                    .font(.custom("Nunito-ExtraBold", size: 24))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Card Number")
                    .font(.custom("Nunito-SemiBold", size: 16))
                    .foregroundColor(.black)
                TextField("1234 5678 9012 3456", text: .constant(""))
                    .font(.custom("Nunito-Regular", size: 16))
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
                
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("Expiry Date")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(.black)
                        TextField("MM/YY", text: .constant(""))
                            .font(.custom("Nunito-Regular", size: 16))
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .keyboardType(.numberPad)
                    }
                    VStack(alignment: .leading) {
                        Text("CVV")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(.black)
                        TextField("123", text: .constant(""))
                            .font(.custom("Nunito-Regular", size: 16))
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .keyboardType(.numberPad)
                    }
                }
                
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("Country")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(.black)
                        TextField("United States", text: .constant("United States"))
                            .font(.custom("Nunito-Regular", size: 16))
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    VStack(alignment: .leading) {
                        Text("ZIP Code")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(.black)
                        TextField("12345", text: .constant(""))
                            .font(.custom("Nunito-Regular", size: 16))
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .keyboardType(.numberPad)
                    }
                }
                
                Button(action: {
                    withAnimation(.easeOut(duration: 0.15)) {
                        print("Save Payment Method tapped")
                    }
                }) {
                    Text("Save Payment Method")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // Mock backend functions
    private func fetchGeocodeAddress(_ address: String) -> Coordinate? {
        print("Mock fetchGeocodeAddress for: \(address)")
        return nil
    }
    
    private func fetchFare(_ from: String, _ to: String, _ promo: Double, _ stop1: String?, _ stop2: String?) -> FareData? {
        print("Mock fetchFare for: from=\(from), to=\(to), promo=\(promo), stop1=\(stop1 ?? "none"), stop2=\(stop2 ?? "none")")
        return nil
    }
    
    private func getRouteCoordinates(start: Coordinate, pickup: Coordinate, dropoff: Coordinate, stop1: Coordinate?, stop2: Coordinate?) -> [Coordinate] {
        print("Mock getRouteCoordinates for: start=\(start), pickup=\(pickup), dropoff=\(dropoff), stop1=\(stop1?.description ?? "none"), stop2=\(stop2?.description ?? "none")")
        return [start, pickup, dropoff]
    }
    
    // Ride data for logging
    private var rideData: [String: Any] {
        [
            "rideType": selectedRide,
            "price": price[selectedRide] ?? 0.0,
            "promo": promo,
            "distance": distance ?? 0.0,
            "from": from,
            "to": to,
            "fromCoords": fromCoords.description,
            "toCoords": toCoords.description,
            "stop1": stop1 ?? "none",
            "stop2": stop2 ?? "none",
            "stop1Coords": stop1Coords.description,
            "stop2Coords": stop2 != nil ? stop1Coords.description : "none"
        ]
    }
}

// Models
struct RideOption: Identifiable {
    let id: String
    let type: String
    let capacity: Int
    let duration: String
    let icon: String
    let tag: String?
}

struct Coordinate: CustomStringConvertible {
    let latitude: Double
    let longitude: Double
    
    var description: String {
        "(\(latitude), \(longitude))"
    }
}

struct FareData {
    let fares: [String: Double]
    let distanceMiles: Double
}

// Sample ride options
let rideOptions: [RideOption] = [
    RideOption(id: "1", type: "Birdy X", capacity: 4, duration: "13 min away", icon: "car-outline", tag: nil),
    RideOption(id: "2", type: "Birdy XL", capacity: 4, duration: "13 min away", icon: "car-outline", tag: nil),
    RideOption(id: "3", type: "Birdy Premium", capacity: 4, duration: "13 min away", icon: "car-outline", tag: nil),
    RideOption(id: "4", type: "Birdy PremiumXL", capacity: 4, duration: "13 min away", icon: "car-outline", tag: nil)
]

struct ChooseRide_Previews: PreviewProvider {
    static var previews: some View {
        ChooseRide()
    }
}