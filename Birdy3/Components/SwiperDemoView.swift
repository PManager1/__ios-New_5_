

// SwiperDemoView


//  {
//         "_id" = 688bbe4e9ff0e89dfc7c8327;
//         from = "266 Washington Boulevard, Washington, DC, USA";
//         fromCoords =         {
//             coordinates =             (
//                 "-91.69414329999999",
//                 "41.2986539"
//             );
//             type = Point;
//         };
//         price = "41.27";
//         promo = 7;
//         rideType = "Birdy X";
//         time = "2025-07-31T19:04:46.569Z";
//         to = "28 Froude Cir, Cabin John, MD";
//         toCoords =         {
//             coordinates =             (
//                 "-77.1503659",
//                 "38.97223160000001"
//             );
//             type = Point;
//         };
//     },

// SwiperDemoView



import SwiftUI
// Define City struct with a unique namespace to avoid conflicts
struct ExploreCity: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let description: String
}

// Static array of city data
let cities = [
    ExploreCity(name: "New York", latitude: 40.7128, longitude: -74.0060, description: "The city that never sleeps"),
    ExploreCity(name: "Paris", latitude: 48.8566, longitude: 2.3522, description: "City of love and lights"),
    ExploreCity(name: "Tokyo", latitude: 35.6762, longitude: 139.6503, description: "Vibrant metropolis of tradition and tech"),
    ExploreCity(name: "Sydney", latitude: -33.8688, longitude: 151.2093, description: "Harbor city with iconic opera house"),
    ExploreCity(name: "Cape Town", latitude: -33.9249, longitude: 18.4241, description: "Stunning views at Table Mountain")
]

// Swipeable Card View
struct CardSwipeView: View {
    let city: ExploreCity
    let onSwipeComplete: () -> Void
    
    // State variables for card animation
    @State private var offset = CGSize.zero
    @State private var opacity = 1.0
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
            
            VStack(spacing: 10) {
                Text(city.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(city.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Lat: \(String(format: "%.4f", city.latitude))")
                    Text("Lon: \(String(format: "%.4f", city.longitude))")
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding()
        }
        .frame(width: 300, height: 400)
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
                            // Swipe completed
                            offset.width = offset.width > 0 ? 1000 : -1000
                            opacity = 0
                            onSwipeComplete() // Trigger callback to advance to next card
                        } else {
                            // Return to original position
                            offset = .zero
                            rotation = 0
                            opacity = 1
                        }
                    }
                }
        )
        // Reset state when city changes to ensure new card starts fresh
        .onChange(of: city.id) { _ in
            offset = .zero
            opacity = 1.0
            rotation = 0.0
        }
    }
}

struct SwiperDemoView: View {
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            VStack {
                if currentIndex < cities.count {
                    // Use id to force SwiftUI to recreate the view for each card
                    CardSwipeView(city: cities[currentIndex]) {
                        withAnimation {
                            currentIndex += 1
                        }
                    }
                    .id(cities[currentIndex].id) // Ensure view is recreated for each card
                } else {
                    Text("No more cities to explore!")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Explore Cities")
    }
}

struct SwiperDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SwiperDemoView()
        }
    }
}
