/*
import SwiftUI

// Navigation Controller View
struct NavigationControllerView: View {
//    @StateObject private var authManager = AuthManager()
    @State private var showSplash = true
    
    var body: some View {
        NavigationStack {
//            Group {
//                if showSplash {
//                    SplashScreenView()
//                } else {
//                    if authManager.isLoggedIn {
//                        HomeView()
//                    } else {
//                        SignInView()
//                    }
//                }
//            }
            Group {
                           if showSplash {
                               SplashScreenView()
                           } else {
                               // Directly show the HomeView
                               HomeView()
                           }
                       }
                   }
        .onAppear {
            // Display splash screen for 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}


 


// Preview
struct NavigationControllerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationControllerView()
            .environmentObject(AuthManager())
    }
}




// Auth Manager to handle login state
class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        // Check for existing token (e.g., from UserDefaults)
        if let _ = UserDefaults.standard.string(forKey: "loginToken") {
            isLoggedIn = true
        }
    }
    
    func signIn(token: String) {
        UserDefaults.standard.set(token, forKey: "loginToken")
        isLoggedIn = true
    }
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "loginToken")
        isLoggedIn = false
    }
}

*/






import SwiftUI

// MARK: - NavigationControllerView

struct NavigationControllerView: View {
    // @StateObject private var authManager = AuthManager() // Kept commented as per original
    @State private var showSplash = true
    @State private var path = NavigationPath() // This will manage your navigation stack

    var body: some View {
        NavigationStack(path: $path) { // Bind NavigationStack to the path
            Group {
                if showSplash {
                    SplashScreenView()
                } else {
                    // This is your initial view after splash, passing the path
                    // If you integrate authManager, you'd put the conditional logic here:
                    // if authManager.isLoggedIn {
                    //     HomeView()
                    // } else {
                    //     SignInView(path: $path)
                    // }
                    
                    // For now, directly showing SignInView as per previous context
                    // SignInView(path: $path) // Pass the path to SignInView
                    HomeView(path: $path)
                    
                }
            }
        }
        // MARK: - Navigation Destination Mapping
        // This modifier tells the NavigationStack how to present each AppRoute case.
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .signIn:
                // If you ever need to navigate back to the SignIn screen
                SignInView(path: $path)
            case .VerifyOtp(let phoneNumber):
                // This maps AppRoute.verifyOtp to your VerifyOtp view
                // Ensure your VerifyOtp struct is Hashable in its own file!
                VerifyOtp(phoneNumber: phoneNumber)
            case .home:
                // Placeholder for your actual HomeView
                // HomeView()
               HomeView(path: $path)
            case .profile:
                // Placeholder for your actual ProfileView
                ProfileView()
            case .settings:
                // Placeholder for your actual SettingsView
                SettingsView()
            case .testScreens:
                // Placeholder for your actual TestScreens (if still needed)
                TestScreens()
            case .userSettings:
                // Placeholder for your actual UserSettingsView
                UserSettingsView()
            }
        }
        .onAppear {
            // Display splash screen for 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}


 
struct ProfileView: View {
    var body: some View {
        Text("User Profile")
            .font(.largeTitle)
            .navigationTitle("Profile")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("App Settings")
            .font(.largeTitle)
            .navigationTitle("Settings")
    }
}

struct TestScreens: View {
    var body: some View {
        Text("Developer Test Screens")
            .font(.largeTitle)
            .navigationTitle("Test")
    }
}

struct UserSettingsView: View {
    var body: some View {
        Text("User Preferences")
            .font(.largeTitle)
            .navigationTitle("User Settings")
    }
}



// MARK: - Preview
struct NavigationControllerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationControllerView()
            // .environmentObject(AuthManager()) // Kept commented as per original
    }
}
