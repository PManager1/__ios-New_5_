//import SwiftUI
//import Combine
//
//struct VerifyOtp: View {
//    let phoneNumber: String
//    @Binding var path: NavigationPath
//    @State private var otp: String = ""
//    @State private var loading = false
//    @State private var resendLoading = false
//    @State private var errorMessage: String? = nil
//    @State private var showSuccessAlert = false
//    @State private var inputScale: CGFloat = 1.0
//    @State private var verifyButtonScale: CGFloat = 1.0
//    @State private var resendButtonScale: CGFloat = 1.0
//    @FocusState private var otpFieldIsFocused: Bool
//    @EnvironmentObject var authStore: AuthStore
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Birdy Connect")
//                .font(.custom("Nunito-Bold", size: 28))
//                .foregroundColor(Color.blue)
//            
//            Text("Enter the OTP code sent to \(phoneNumber)")
//                .font(.custom("Nunito-Regular", size: 16))
//                .foregroundColor(Color.blue)
//            
//            // OTP Input with Animation
//            TextField("Enter OTP", text: $otp)
//                .font(.custom("Nunito-Regular", size: 16))
//                .keyboardType(.numberPad)
//                .padding()
//                .background(Color.white)
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
//                )
//                .padding(.horizontal)
//                .scaleEffect(inputScale)
//                .focused($otpFieldIsFocused)  // <- added here 
//                .onTapGesture {
//                    withAnimation(.spring()) {
//                        inputScale = 1.05
//                    }
//                }
//                .onChange(of: otp) { _ in
//                    errorMessage = nil
//                    withAnimation(.spring()) {
//                        inputScale = 1.0
//                    }
//                }
//            
//            if let error = errorMessage {
//                Text(error)
//                    .font(.custom("Nunito-Regular", size: 14))
//                    .foregroundColor(.red)
//                    .padding(.horizontal)
//                    .multilineTextAlignment(.center)
//            }
//            
//            // Verify OTP Button with Animation
//            Button(action: handleVerifyOTP) {
//                Text(loading ? "Sending..." : "Verify OTP")
//                    .font(.custom("Nunito-Bold", size: 16))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.blue, Color(red: 59/255, green: 130/255, blue: 246/255)]),
//                            startPoint: .leading,
//                            endPoint: .trailing
//                        )
//                    )
//                    .cornerRadius(25)
//                    .scaleEffect(verifyButtonScale)
//            }
//            .disabled(loading || otp.isEmpty)
//            .padding(.horizontal)
//            .onTapGesture {
//                withAnimation(.spring()) {
//                    verifyButtonScale = 0.95
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    withAnimation(.spring()) {
//                        verifyButtonScale = 1.0
//                    }
//                }
//            }
//            
//            // Resend OTP Button with Animation
//            Button(action: handleResendOTP) {
//                Text(resendLoading ? "Resending..." : "Resend Code")
//                    .font(.custom("Nunito-Regular", size: 16))
//                    .foregroundColor(Color.green)
//                    .scaleEffect(resendButtonScale)
//            }
//            .disabled(resendLoading)
//            .onTapGesture {
//                withAnimation(.spring()) {
//                    resendButtonScale = 0.95
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    withAnimation(.spring()) {
//                        resendButtonScale = 1.0
//                    }
//                }
//            }
//            
//            Spacer()
//        }
//        .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    otpFieldIsFocused = true
//                }
//            }
//        .padding()
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [
//                    Color(red: 230/255, green: 240/255, blue: 250/255),
//                    Color(red: 179/255, green: 205/255, blue: 224/255)
//                ]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//        )
//     
//        .alert(isPresented: $showSuccessAlert) {
//            Alert(
//                title: Text("Success"),
//                message: Text("OTP verified successfully"),
//                dismissButton: .default(Text("OK")) {
//                    path.removeLast(path.count - 1) // Clear to SignIn, keep one back to Main Menu
//                    path.append(AppRoute.testScreens)
//                }
//            )
//        }
//    }
//    
//    private func handleVerifyOTP() {
//        if otp.isEmpty {
//            errorMessage = "Please enter an OTP code"
//            return
//        }
//        loading = true
//        errorMessage = nil
//        
//        Task {
//            do {
//                var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/verify-otp")!)
//                request.httpMethod = "POST"
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                let body: [String: Any] = ["phoneNumber": phoneNumber, "otp": otp]
//                request.httpBody = try JSONSerialization.data(withJSONObject: body)
//                
//                let (data, response) = try await URLSession.shared.data(for: request)
//                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                    let errorData = try JSONDecoder().decode(ErrorResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        errorMessage = errorData.error ?? "Failed to verify OTP"
//                        loading = false
//                    }
//                    return
//                }
//                
//                let responseData = try JSONDecoder().decode(VerifyOTPResponse.self, from: data)
//                try await KeychainHelper.saveToken(responseData.token)
//                
//                DispatchQueue.main.async {
//                    authStore.login(token: responseData.token)
//                    loading = false
//                    showSuccessAlert = true
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    errorMessage = "Failed to verify OTP: \(error.localizedDescription)"
//                    loading = false
//                }
//            }
//        }
//    }
//    
//    private func handleResendOTP() {
//        resendLoading = true
//        Task {
//            do {
//                var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/send-otp")!)
//                request.httpMethod = "POST"
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                let body: [String: Any] = ["phoneNumber": phoneNumber]
//                request.httpBody = try JSONSerialization.data(withJSONObject: body)
//                
//                let (data, response) = try await URLSession.shared.data(for: request)
//                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                    let errorData = try JSONDecoder().decode(ErrorResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        errorMessage = errorData.error ?? "Failed to resend OTP"
//                        resendLoading = false
//                    }
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    errorMessage = "OTP resent successfully"
//                    resendLoading = false
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    errorMessage = "Failed to resend OTP: \(error.localizedDescription)"
//                    resendLoading = false
//                }
//            }
//        }
//    }
//}
//
//struct VerifyOtp_Previews: PreviewProvider {
//    @State static var path = NavigationPath()
//    
//    static var previews: some View {
//        VerifyOtp(phoneNumber: "+1234567890", path: $path)
//            .environmentObject(AuthStore())
//    }
//}
