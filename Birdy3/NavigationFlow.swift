
import SwiftUI

struct NavigationFlow: View {
    @State private var showSplash = true
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if showSplash {
                    SplashScreenView()
                } else {
                    HomeView(path: $path)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .home:
                    HomeView(path: $path)
                case .signIn:
                    SignInView(path: $path)
                case .verifyOtp(let phoneNumber):
                    VerifyOtp(phoneNumber: phoneNumber, path: $path)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

struct NavigationFlow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationFlow()
    }
}


