import SwiftUI

struct UserSettingView: View {
    @Binding var path: NavigationPath
    @State private var token: String? = nil
    @State private var isTokenValid: Bool? = nil
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("User Settings")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Token: \(token ?? "No token available")")
                .font(.body)
                .foregroundColor(.gray)
                .accessibilityLabel("Token: \(token ?? "No token available")")

            Text(isTokenValid == nil ? "Checking token..." : isTokenValid == true ? "Token is valid" : "Token is invalid")
                .font(.body)
                .foregroundColor(isTokenValid == true ? .green : .red)
                .accessibilityLabel(isTokenValid == nil ? "Checking token" : isTokenValid == true ? "Token is valid" : "Token is invalid")

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .accessibilityLabel("Error: \(errorMessage)")
            }

          

            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
        .onAppear {
            validateToken()
        }
    }

   

    private func validateToken() {
    guard let token = AuthManager.shared.getToken() else {
        errorMessage = "No token available"
        isTokenValid = false
        return
    }
    self.token = token

    Task {
        do {
            var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/validate-token")!)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: request)

            // Debug log
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received backend response: \(jsonString)")
            }

            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.isTokenValid = true
                    self.errorMessage = nil
                } else {
                    self.isTokenValid = false
                    if let errorData = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        self.errorMessage = errorData.error ?? "Token validation failed"
                    } else {
                        self.errorMessage = "Token validation failed"
                    }
                }
            }

        } catch {
            DispatchQueue.main.async {
                self.isTokenValid = false
                self.errorMessage = "Failed to connect: \(error.localizedDescription)"
            }
        }
    }
}


}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserSettingView(path: .constant(NavigationPath()))
        }
    }
}



/*
 import SwiftUI
 import Combine

 struct UserSettingView: View {
     @Binding var path: NavigationPath
     @EnvironmentObject var authStore: AuthStore
     @State private var token: String? = nil
     @State private var isLoading = true
     @State private var buttonScale: CGFloat = 1.0
    
     var body: some View {
         VStack(spacing: 20) {
             Text("User Settings")
                 .font(.custom("Nunito-Bold", size: 28))
                 .foregroundColor(.blue)
            
             if isLoading {
                 ProgressView("Checking authentication...")
                     .font(.custom("Nunito-Regular", size: 16))
                     .foregroundColor(.gray)
             } else if let token = token {
                 VStack(spacing: 10) {
                     Text("Authentication Token")
                         .font(.custom("Nunito-Regular", size: 16))
                         .foregroundColor(.gray)
                    
                     Text(token)
                         .font(.custom("Nunito-Regular", size: 14))
                         .foregroundColor(.black)
                         .padding()
                         .background(Color.white)
                         .cornerRadius(10)
                         .overlay(
                             RoundedRectangle(cornerRadius: 10)
                                 .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                         )
                         .padding(.horizontal)
                    
                     Button(action: {
                         Task {
                             try? await KeychainHelper.deleteToken()
                             authStore.logout()
                             path.removeLast(path.count) // Clear stack to return to Main Menu
                         }
                     }) {
                         Text("Sign Out")
                             .font(.custom("Nunito-Bold", size: 16))
                             .foregroundColor(.white)
                             .frame(maxWidth: .infinity)
                             .padding()
                             .background(
                                 LinearGradient(
                                     gradient: Gradient(colors: [Color.blue, Color(red: 59/255, green: 130/255, blue: 246/255)]),
                                     startPoint: .leading,
                                     endPoint: .trailing
                                 )
                             )
                             .cornerRadius(25)
                             .scaleEffect(buttonScale)
                     }
                     .padding(.horizontal)
                     .onTapGesture {
                         withAnimation(.spring()) {
                             buttonScale = 0.95
                         }
                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                             withAnimation(.spring()) {
                                 buttonScale = 1.0
                             }
                         }
                     }
                 }
             } else {
                 Text("No token found")
                     .font(.custom("Nunito-Regular", size: 16))
                     .foregroundColor(.gray)
                
                 Button(action: { path.removeLast() }) { // Back to Main Menu
                     Text("Back to Main Menu")
                         .font(.custom("Nunito-Bold", size: 16))
                         .foregroundColor(.white)
                         .frame(maxWidth: .infinity)
                         .padding()
                         .background(
                             LinearGradient(
                                 gradient: Gradient(colors: [Color.blue, Color(red: 59/255, green: 130/255, blue: 246/255)]),
                                 startPoint: .leading,
                                 endPoint: .trailing
                             )
                         )
                         .cornerRadius(25)
                         .scaleEffect(buttonScale)
                 }
                 .padding(.horizontal)
                 .onTapGesture {
                     withAnimation(.spring()) {
                         buttonScale = 0.95
                     }
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                         withAnimation(.spring()) {
                             buttonScale = 1.0
                         }
                     }
                 }
             }
            
             Spacer()
         }
         .padding()
         .background(
             LinearGradient(
                 gradient: Gradient(colors: [
                     Color(red: 230/255, green: 240/255, blue: 250/255),
                     Color(red: 179/255, green: 205/255, blue: 224/255)
                 ]),
                 startPoint: .topLeading,
                 endPoint: .bottomTrailing
             )
             .ignoresSafeArea()
         )
        //  .onAppear {
        //      checkToken()
        //  }
        .onAppear {
            Task { // Create an asynchronous context for the async function
                await checkToken()
            }
        }

     }
    
    //  private func checkToken() {
    //      Task {
    //          do {
    //              if let savedToken = try await KeychainHelper.getToken() {
    //                  let isValid = await validateToken(savedToken)
    //                  if isValid {
    //                      DispatchQueue.main.async {
    //                          token = savedToken
    //                          authStore.login(token: savedToken)
    //                      }
    //                  } else {
    //                      try await KeychainHelper.deleteToken()
    //                      authStore.logout()
    //                      DispatchQueue.main.async {
    //                          token = nil
    //                      }
    //                  }
    //              } else {
    //                  DispatchQueue.main.async {
    //                      token = nil
    //                  }
    //              }
    //          } catch {
    //              print("Error checking token: \(error)")
    //              try? await KeychainHelper.deleteToken()
    //              authStore.logout()
    //              DispatchQueue.main.async {
    //                  token = nil
    //              }
    //          }
    //          DispatchQueue.main.async {
    //              isLoading = false
    //              path.removeLast(path.count - 1) // Ensure single back button to Main Menu
    //          }
    //      }
    //  }

      private func checkToken() async {
        isLoading = true // Start loading indicator
        Task {
            defer {
                // Ensure isLoading is set to false regardless of the outcome
                DispatchQueue.main.async { isLoading = false }
            }

            // Get token directly from AuthManager (which reads from Keychain)
            if let currentToken = AuthManager.shared.getToken() {
                let isValid = await validateToken(currentToken)
                // if isValid {
                //     // If the token is valid, ensure authStore reflects this.
                //     // This is important if AuthStore might not have been fully initialized
                //     // or its state wasn't updated from Keychain on app launch yet.
                //     DispatchQueue.main.async {
                //         authStore.login(token: currentToken) // Update authStore's observable state
                //         print("✅ Token is valid and authStore updated.")
                //     }
                // }
                if isValid {
                         // Provide an async context for the 'authStore.login' call
                         // within the DispatchQueue.main.async block.
                         DispatchQueue.main.async {
                             Task {
                                 await authStore.login(token: currentToken) // <-- ADD 'await' HERE
                             }
                             print("✅ Token is valid and authStore updated.")
                         }
                     }
                 else {
                    // Token is invalid on backend, so clear it
                    print("❌ Token invalid based on backend validation. Logging out.")
                    AuthManager.shared.setToken(nil) // Clear token from Keychain via AuthManager
                    DispatchQueue.main.async {
                        authStore.logout() // Update authStore's observable state
                    }
                }
            } else {
                // No token found by AuthManager (meaning not in Keychain)
                print("⚠️ No token found by AuthManager. Ensuring authStore is logged out.")
                DispatchQueue.main.async {
                    authStore.logout() // Ensure authStore reflects logged-out state
                }
            }

            // This line for path navigation might cause issues if placed here.
            // Consider its removal or conditional execution based on your overall app navigation flow.
            // path.removeLast(path.count - 1) // Ensure single back button to Main Menu
        }
    }
    
     private func validateToken(_ token: String) async -> Bool {
         do {
             var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/validate-token")!)
             request.httpMethod = "GET"
             request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
             request.addValue("application/json", forHTTPHeaderField: "Content-Type")


             if let token = AuthManager.shared.getToken() {
                // This is the crucial line. We are adding a value to the 'request'
                // declared at the top of this 'do' block, NOT creating a new one.
                print("➡️ Attaching Authorization header with token (first 10 chars): \(token.prefix(10))...")
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("⚠️ AuthManager: No token found. Cannot attach Authorization header for trips request.")
                // Decide how to handle no token: potentially show an error, redirect to login, etc.
                // For now, the request will proceed without the header, likely failing due to auth.
            }
            
             let (data, response) = try await URLSession.shared.data(for: request)
             guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                 print("Token validation failed: \(response)")
                 return false
             }
             return true
         } catch {
             print("Error validating token: \(error)")
             return false
         }
     }
 }

struct UserSettingView_Previews: PreviewProvider {
    @State static var path = NavigationPath()
    
    static var previews: some View {
        
        //        UserSettingView(path: $path)
        //            .environmentObject(AuthStore())
        NavigationStack {
            UserSettingView(path: .constant(NavigationPath()))
        }
    }
}


*/
