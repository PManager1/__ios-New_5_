 
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


/*

import SwiftUI

struct VerifyOtp: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var otp: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter OTP")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("6-digit OTP", text: $otp)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal)
                .accessibilityLabel("Enter 6-digit OTP")
            
            if authViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .accessibilityLabel("Loading")
            } else {
                Button(action: {
                    authViewModel.verifyOTP(otp: otp)
                }) {
                    Text("Verify")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(otp.count != 6)
                .accessibilityLabel("Verify OTP")
                
                Button(action: {
                    authViewModel.resendOTP()
                }) {
                    Text("Resend OTP")
                        .font(.body)
                        .foregroundColor(.blue)
                }
                .accessibilityLabel("Resend OTP")
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Verify OTP")
        .alert(isPresented: $authViewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(authViewModel.errorMessage ?? "An error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationDestination(isPresented: $authViewModel.isAuthenticated) {
            HomeView()
                .environmentObject(authViewModel)
        }
        .onAppear {
            otp = ""
        }
    }
}

struct VerifyOtp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VerifyOtp()
                .environmentObject(AuthViewModel())
        }
    }
}
*/








import SwiftUI
import Combine

struct VerifyOtp: View {
    let phoneNumber: String?
    
    @State private var otp: String = ""
    @State private var loading = false
    @State private var resendLoading = false
    @State private var errorMessage: String? = nil
    @State private var showSuccessAlert = false
    
    @State private var inputScale: CGFloat = 1.0
    @State private var verifyButtonScale: CGFloat = 1.0
    @State private var resendButtonScale: CGFloat = 1.0
    
    @FocusState private var otpFieldIsFocused: Bool
    
    init(phoneNumber: String? = nil) {
        self.phoneNumber = phoneNumber
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Birdy Connect")
                .font(.custom("Nunito-Bold", size: 28)) // Applying Nunito-Bold
                .foregroundColor(Color.blue)
            
            Text("Enter the OTP code sent to \(phoneNumber ?? "your phone")") // Applying Nunito-Regular
                .font(.custom("Nunito-Regular", size: 16))
                .foregroundColor(Color.blue)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            TextField("Enter OTP", text: $otp)
                .font(.custom("Nunito-Regular", size: 16)) // Applying Nunito-Regular
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
                .scaleEffect(inputScale)
                .focused($otpFieldIsFocused)
                .onTapGesture {
                    withAnimation(.spring()) {
                        inputScale = 1.05
                    }
                }
                .onChange(of: otp) { _ in
                    errorMessage = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring()) { inputScale = 1.0 }
                    }
                }
            
            if let error = errorMessage {
                Text(error)
                    .font(.custom("Nunito-Regular", size: 14)) // Applying Nunito-Regular
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if otp.isEmpty {
                    errorMessage = "Please enter the OTP code."
                    return
                }
                loading = true
                errorMessage = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    loading = false
                    showSuccessAlert = true
                }
            }) {
                HStack {
                    if loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(loading ? "Verifying..." : "Verify OTP")
                }
                .font(.custom("Nunito-Bold", size: 16)) // Applying Nunito-Bold
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
                .scaleEffect(verifyButtonScale)
            }
            .disabled(loading || otp.isEmpty)
            .padding(.horizontal)
            .onTapGesture {
                withAnimation(.spring()) { verifyButtonScale = 0.95 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) { verifyButtonScale = 1.0 }
                }
            }
            
            Button(action: {
                resendLoading = true
                errorMessage = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    resendLoading = false
                    errorMessage = "OTP resent successfully! Check your phone."
                }
            }) {
                HStack {
                    if resendLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    }
                    Text(resendLoading ? "Resending..." : "Resend Code")
                }
                .font(.custom("Nunito-Regular", size: 16)) // Applying Nunito-Regular
                .foregroundColor(Color.green)
                .scaleEffect(resendButtonScale)
            }
            .disabled(resendLoading)
            .onTapGesture {
                withAnimation(.spring()) { resendButtonScale = 0.95 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) { resendButtonScale = 1.0 }
                }
            }
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                otpFieldIsFocused = true
            }
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
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("OTP verified successfully!"),
                dismissButton: .default(Text("OK")) {}
            )
        }
    }
}

struct VerifyOtp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VerifyOtp(phoneNumber: "+1234567890")
        }
    }
}
