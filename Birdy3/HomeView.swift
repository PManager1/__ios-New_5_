import SwiftUI

struct HomeView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Birdy")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button(action: {
                path.append(AppRoute.signIn)
            }) {
                Text("Go to Sign In")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Go to Sign In")




            Button(action: {
                print("Home Button 1 tapped")
            }) {
                Text("Home Button 1")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Home Button 1")

            Button(action: {
                print("Home Button 2 tapped")
            }) {
                Text("Home Button 2")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Home Button 2")

            Button(action: {
                print("Home Button 3 tapped")
            }) {
                Text("Home Button 3")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Home Button 3")

            Button(action: {
                print("Home Button 4 tapped")
            }) {
                Text("Home Button 4")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Home Button 4")

            Spacer()
        }
        .padding()
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView(path: .constant(NavigationPath()))
        }
    }
}



/*
import SwiftUI
struct HomeView: View {
    var body: some View {
        NavigationView {
             ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    Text("Test screens")
                        .font(.custom("Nunito-Bold", size: 24))
                        .padding(.bottom, 10)
                    
                    // Old Stuff Section
                    Text("Old stuff")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(Color(red: 30/255, green: 64/255, blue: 175/255))
                        .padding(.top, 10)

                        NavigationLink("Profile", destination: Text("Profile Screen"))
                        NavigationLink("Trips", destination: Text("Trips Screen"))
//                    SettingsButton(title: " CurrentLocation", color: Color(hex: "#FF9800"), destination: { CurrentLocation() })
//                    SettingsButton(title: " GoMapView", color: Color(hex: "#FF9800"), destination: { GoMapView() })
                    // SettingsButton(title: "Cards", color: Color(hex: "#FF9800"), destination: { SwiperDemoView() })

                    // SettingsButton(title: "Sign in", color: Color(hex: "#FF9800"), destination: { SignInView(path: $path) })

                    SettingsButton(title: "Sign in", color: Color(hex: "#FF9800"), destination: { SignInView  })
                    
                    
                    
//             SettingsButton(title: "Sign in", color: Color(hex: "#FF9800"), destination: { SignInView() })
                   
                    // SettingsButton(title: "GoogleMapView", color: Color(hex: "#FF9800"), destination: { GoogleMapView() })
//                    SettingsButton(title: "Google screws things up", color: Color(hex: "#FF9800"), destination: { GoogleSignInView() })
                    // SettingsButton(title: "UserStats", color: Color(hex: "#FF9800"), destination: { UserStats() })
                    
                    // Rider Section
                    DividerView()
                    Text("Rider")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(Color(red: 30/255, green: 64/255, blue: 175/255))
                        .padding(.top, 10)
                    // SettingsButton(title: "Rider Home", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { RiderHome() })
                    // SettingsButton(title: "Choose Ride", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { ChooseRide() })
                    // SettingsButton(title: "Ride Plan", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { RidePlan() })
                    // SettingsButton(title: "Ride Confirm", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { RideConfirm() })
                    
                    // Driver Section
                    DividerView()
                    Text("Driver")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(Color(red: 30/255, green: 64/255, blue: 175/255))
                        .padding(.top, 10)
                    // SettingsButton(title: "Map Test Screen", color: Color(hex: "#FF9800"), destination: { GoMapView() })
                    // SettingsButton(title: "V Arrived", color: Color(hex: "#FF9800"), destination: { VArrived() })

                    // SettingsButton(title: "Driver Detail", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { DriverDetail() })
                    // SettingsButton(title: "Driver Directory", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { DriverDirectory() })
                    // SettingsButton(title: "RateCard", color: Color(hex: "#FF9800"), destination: { RateCardView() })
                    // SettingsButton(title: "Help & Safety", color: Color(hex: "#FF9800"), destination: { PlaceholderView(name: "Help & Safety") })
                    // SettingsButton(title: "Add Client", color: Color(hex: "#FF9800"), destination: { AddClient() })
                    // SettingsButton(title: "Ride Incoming", color: Color(hex: "#FF9800"), destination: { PlaceholderView(name: "Ride Incoming") })
                    
                    // Other Screens Section
                    DividerView()
                    Text("Other Screens")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(Color(red: 30/255, green: 64/255, blue: 175/255))
                        .padding(.top, 10)
                    // SettingsButton(title: "Force Save Push Token", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Force Save Push Token") })
                    // SettingsButton(title: "Share My Location", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Share My Location") })
                    // SettingsButton(title: "Send Location Manually", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Send Location Manually") })
                    // SettingsButton(title: "Google Auth Screen", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { GoogleSignInView() })
                    // SettingsButton(title: "Take Photo", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Take Photo") })
                    // SettingsButton(title: "Driver Edit", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Driver Edit") })
                    // SettingsButton(title: "Svc Selection", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Svc Selection") })
                    // SettingsButton(title: "RiderDriverSelect", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "RiderDriverSelect") })
                    // SettingsButton(title: "Image Upload Screen", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Image Upload Screen") })
                    // SettingsButton(title: "Send Push Notification", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Send Push Notification") })
                    // SettingsButton(title: "SwipeButtonScreen", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "SwipeButtonScreen") })
                    // SettingsButton(title: "BirdySignage", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "BirdySignage") })
                    // SettingsButton(title: "Delete Account", color: Color(red: 30/255, green: 64/255, blue: 175/255), destination: { PlaceholderView(name: "Delete Account") })
                    // SettingsButton(title: "User Setting View", color: Color(hex: "#FF9800"), destination: { UserSettingView(path: $path) })


                    // Existing ContentView Buttons (non-duplicates)
                    // SettingsButton(title: "Sign In Phone", color: Color.blue, destination: { SignInView(path: $path) })
                    // SettingsButton(title: "Profile", color: Color.blue, destination: { ProfileView() })
                    // SettingsButton(title: "Google Map", color: Color.blue, destination: { GoogleMapView() })
                }
                .padding()
            }
            
            // Drawer
        //     GeometryReader { geometry in
        //         HStack(spacing: 0) {
        //             NavBarView()
        //                 .frame(width: geometry.size.width)
        //                 .background(Color.white)
        //                 .offset(x: isDrawerOpen ? 0 : -geometry.size.width)
        //                 .animation(.easeInOut(duration: 0.3), value: isDrawerOpen)
        //         }
        //     }
        //     .background(
        //         Color.black.opacity(isDrawerOpen ? 0.5 : 0)
        //             .ignoresSafeArea()
        //             .onTapGesture {
        //                 if isDrawerOpen {
        //                     isDrawerOpen = false
        //                 }
        //             }
        //     )
        }
            .navigationTitle("More Screens")
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



// import SwiftUI

// struct HomeView: View {
//     var body: some View {
//         NavigationView {
//             ZStack {
//                 Color.gray.opacity(0.2)
//                     .ignoresSafeArea()
                
//                 VStack(spacing: 20) {
//                     Text("Home Screen")
//                         .font(.largeTitle)
//                         .fontWeight(.bold)
                    
//                     // Links / Buttons
//                     NavigationLink("Profile", destination: Text("Profile Screen"))
//                     NavigationLink("Trips", destination: Text("Trips Screen"))
//                     NavigationLink("Settings", destination: Text("Settings Screen"))
//                     NavigationLink("Support", destination: Text("Support Screen"))
//                     NavigationLink("About", destination: Text("About Screen"))
//                 }
//                 .padding()
//             }
//             .navigationTitle("More Screens")
//         }
//     }
// }

// struct HomeView_Previews: PreviewProvider {
//     static var previews: some View {
//         HomeView()
//     }
// }


*/