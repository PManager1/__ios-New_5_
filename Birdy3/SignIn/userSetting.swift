// import SwiftUI
// import Combine

// struct UserSettingView: View {
//     @Binding var path: NavigationPath
//     @EnvironmentObject var authStore: AuthStore
//     @State private var token: String? = nil
//     @State private var isLoading = true
//     @State private var buttonScale: CGFloat = 1.0
    
//     var body: some View {
//         VStack(spacing: 20) {
//             Text("User Settings")
//                 .font(.custom("Nunito-Bold", size: 28))
//                 .foregroundColor(.blue)
            
//             if isLoading {
//                 ProgressView("Checking authentication...")
//                     .font(.custom("Nunito-Regular", size: 16))
//                     .foregroundColor(.gray)
//             } else if let token = token {
//                 VStack(spacing: 10) {
//                     Text("Authentication Token")
//                         .font(.custom("Nunito-Regular", size: 16))
//                         .foregroundColor(.gray)
                    
//                     Text(token)
//                         .font(.custom("Nunito-Regular", size: 14))
//                         .foregroundColor(.black)
//                         .padding()
//                         .background(Color.white)
//                         .cornerRadius(10)
//                         .overlay(
//                             RoundedRectangle(cornerRadius: 10)
//                                 .stroke(Color.blue.opacity(0.5), lineWidth: 1)
//                         )
//                         .padding(.horizontal)
                    
//                     Button(action: {
//                         Task {
//                             try? await KeychainHelper.deleteToken()
//                             authStore.logout()
//                             path.removeLast(path.count) // Clear stack to return to Main Menu
//                         }
//                     }) {
//                         Text("Sign Out")
//                             .font(.custom("Nunito-Bold", size: 16))
//                             .foregroundColor(.white)
//                             .frame(maxWidth: .infinity)
//                             .padding()
//                             .background(
//                                 LinearGradient(
//                                     gradient: Gradient(colors: [Color.blue, Color(red: 59/255, green: 130/255, blue: 246/255)]),
//                                     startPoint: .leading,
//                                     endPoint: .trailing
//                                 )
//                             )
//                             .cornerRadius(25)
//                             .scaleEffect(buttonScale)
//                     }
//                     .padding(.horizontal)
//                     .onTapGesture {
//                         withAnimation(.spring()) {
//                             buttonScale = 0.95
//                         }
//                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                             withAnimation(.spring()) {
//                                 buttonScale = 1.0
//                             }
//                         }
//                     }
//                 }
//             } else {
//                 Text("No token found")
//                     .font(.custom("Nunito-Regular", size: 16))
//                     .foregroundColor(.gray)
                
//                 Button(action: { path.removeLast() }) { // Back to Main Menu
//                     Text("Back to Main Menu")
//                         .font(.custom("Nunito-Bold", size: 16))
//                         .foregroundColor(.white)
//                         .frame(maxWidth: .infinity)
//                         .padding()
//                         .background(
//                             LinearGradient(
//                                 gradient: Gradient(colors: [Color.blue, Color(red: 59/255, green: 130/255, blue: 246/255)]),
//                                 startPoint: .leading,
//                                 endPoint: .trailing
//                             )
//                         )
//                         .cornerRadius(25)
//                         .scaleEffect(buttonScale)
//                 }
//                 .padding(.horizontal)
//                 .onTapGesture {
//                     withAnimation(.spring()) {
//                         buttonScale = 0.95
//                     }
//                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                         withAnimation(.spring()) {
//                             buttonScale = 1.0
//                         }
//                     }
//                 }
//             }
            
//             Spacer()
//         }
//         .padding()
//         .background(
//             LinearGradient(
//                 gradient: Gradient(colors: [
//                     Color(red: 230/255, green: 240/255, blue: 250/255),
//                     Color(red: 179/255, green: 205/255, blue: 224/255)
//                 ]),
//                 startPoint: .topLeading,
//                 endPoint: .bottomTrailing
//             )
//             .ignoresSafeArea()
//         )
//         .onAppear {
//             checkToken()
//         }
//     }
    
//     private func checkToken() {
//         Task {
//             do {
//                 if let savedToken = try await KeychainHelper.getToken() {
//                     let isValid = await validateToken(savedToken)
//                     if isValid {
//                         DispatchQueue.main.async {
//                             token = savedToken
//                             authStore.login(token: savedToken)
//                         }
//                     } else {
//                         try await KeychainHelper.deleteToken()
//                         authStore.logout()
//                         DispatchQueue.main.async {
//                             token = nil
//                         }
//                     }
//                 } else {
//                     DispatchQueue.main.async {
//                         token = nil
//                     }
//                 }
//             } catch {
//                 print("Error checking token: \(error)")
//                 try? await KeychainHelper.deleteToken()
//                 authStore.logout()
//                 DispatchQueue.main.async {
//                     token = nil
//                 }
//             }
//             DispatchQueue.main.async {
//                 isLoading = false
//                 path.removeLast(path.count - 1) // Ensure single back button to Main Menu
//             }
//         }
//     }
    
//     private func validateToken(_ token: String) async -> Bool {
//         do {
//             var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/validate-token")!)
//             request.httpMethod = "GET"
//             request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//             request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
//             let (data, response) = try await URLSession.shared.data(for: request)
//             guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                 print("Token validation failed: \(response)")
//                 return false
//             }
//             return true
//         } catch {
//             print("Error validating token: \(error)")
//             return false
//         }
//     }
// }

// struct UserSettingView_Previews: PreviewProvider {
//     @State static var path = NavigationPath()
    
//     static var previews: some View {
//         UserSettingView(path: $path)
//             .environmentObject(AuthStore())
//     }
// }