
import SwiftUI
import Combine

struct SignInView: View {
    @State private var phoneNumber: String = ""
    @State private var loading = false
    @State private var demoLoading = false
    @State private var errorMessage: String? = nil
    @State private var showSuccessAlert = false
    @State private var showDemoSuccessAlert = false
    
    @State private var inputScale: CGFloat = 1.0
    @State private var buttonScale: CGFloat = 1.0
    @State private var demoButtonScale: CGFloat = 1.0
    
    @FocusState private var phoneFieldIsFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In to Birdy")
                .font(.custom("Nunito-Bold", size: 28)) // Applying Nunito-Bold
                .foregroundColor(Color.blue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Phone Number")
                    .font(.custom("Nunito-Regular", size: 14)) // Applying Nunito-Regular
                    .foregroundColor(.gray)
                
                TextField("123-456-7890", text: $phoneNumber)
                    .font(.custom("Nunito-Regular", size: 16)) // Applying Nunito-Regular
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                    )
                    .scaleEffect(inputScale)
                    .focused($phoneFieldIsFocused)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            inputScale = 1.05
                        }
                    }
                    .onChange(of: phoneNumber) { newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring()) { inputScale = 1.0 }
                        }
                        let formatted = formatPhoneNumber(newValue)
                        phoneNumber = formatted.formattedNumber
                        errorMessage = formatted.error
                    }
            }
            .padding(.horizontal)
            
            if let error = errorMessage {
                Text(error)
                    .font(.custom("Nunito-Regular", size: 14)) // Applying Nunito-Regular
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                loading = true
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
                    Text(loading ? "Sending..." : "Send me OTP")
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
                .scaleEffect(buttonScale)
            }
            .disabled(loading || !isValidPhoneNumber())
            .padding(.horizontal)
            .onTapGesture {
                withAnimation(.spring()) { buttonScale = 0.95 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) { buttonScale = 1.0 }
                }
            }
            
            Button(action: {
                demoLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    demoLoading = false
                    showDemoSuccessAlert = true
                }
            }) {
                HStack {
                    if demoLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(demoLoading ? "Logging in..." : "Demo Login")
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
                .scaleEffect(demoButtonScale)
            }
            .disabled(demoLoading)
            .padding(.horizontal)
            .onTapGesture {
                withAnimation(.spring()) { demoButtonScale = 0.95 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) { demoButtonScale = 1.0 }
                }
            }
            
            Spacer()
        }
        .padding(.vertical)
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
        .alert(isPresented: Binding<Bool>(
            get: { showSuccessAlert || showDemoSuccessAlert },
            set: { _ in
                showSuccessAlert = false
                showDemoSuccessAlert = false
            }
        )) {
            if showSuccessAlert {
                return Alert(
                    title: Text("Success"),
                    message: Text("OTP sent successfully"),
                    dismissButton: .default(Text("OK")) {}
                )
            } else {
                return Alert(
                    title: Text("Success"),
                    message: Text("Demo login successful"),
                    dismissButton: .default(Text("OK")) {}
                )
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                phoneFieldIsFocused = true
            }
        }
    }
    
    private func formatPhoneNumber(_ input: String) -> (formattedNumber: String, error: String?) {
        let digits = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if digits.count > 10 { return (phoneNumber, "Phone number cannot exceed 10 digits") }
        
        var formatted = ""
        for (index, digit) in digits.enumerated() {
            if index == 3 || index == 6 { formatted += "-" }
            formatted += String(digit)
        }
        
        let error = digits.count < 10 && !digits.isEmpty ? "Phone number must be 10 digits" : nil
        return (formatted, error)
    }
    
    private func isValidPhoneNumber() -> Bool {
        let digits = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return digits.count == 10
    }
    
    private func checkExistingToken() { /* Your original commented out code */ }
    private func validateToken(_ token: String) async -> Bool { return true }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView()
        }
    }
}







/*
import SwiftUI

struct SignInView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            Text("Signiin Dummy Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .navigationTitle("First Screen")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
    }
}

*/

/*

import SwiftUI
import Combine

struct SignInView: View {
//    @Binding var path: NavigationPath   //fix this if needed
    @State private var phoneNumber: String = ""
    @State private var loading = false
    @State private var demoLoading = false
    @State private var errorMessage: String? = nil
    @State private var showSuccessAlert = false
    @State private var showDemoSuccessAlert = false
    @State private var inputScale: CGFloat = 1.0
    @State private var buttonScale: CGFloat = 1.0
    @State private var demoButtonScale: CGFloat = 1.0
    @FocusState private var phoneFieldIsFocused: Bool
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In to Birdy")
                .font(.custom("Nunito-Bold", size: 28))
                .foregroundColor(Color.blue)
            
            // Phone Number Input with Animation
            VStack(alignment: .leading, spacing: 8) {
                Text("Phone Number")
                    .font(.custom("Nunito-Regular", size: 14))
                    .foregroundColor(.gray)
                
                TextField("123-456-7890", text: $phoneNumber)
                    .font(.custom("Nunito-Regular", size: 16))
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                    )
                    .scaleEffect(inputScale)
                     .focused($phoneFieldIsFocused)   // <- added here 
                    .onTapGesture {
                        withAnimation(.spring()) { inputScale = 1.05 }
                    }
                    .onChange(of: phoneNumber) { newValue in
                        let formatted = formatPhoneNumber(newValue)
                        phoneNumber = formatted.formattedNumber
                        errorMessage = formatted.error
                        withAnimation(.spring()) { inputScale = 1.0 }
                    }
            }
            .padding(.horizontal)
            
            if let error = errorMessage {
                Text(error)
                    .font(.custom("Nunito-Regular", size: 14))
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            
            // Send OTP Button
            Button(action: handleSendOTP) {
                Text(loading ? "Sending..." : "Send me OTP")
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
            .disabled(loading || !isValidPhoneNumber())
            .padding(.horizontal)
            .onTapGesture {
                withAnimation(.spring()) { buttonScale = 0.95 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) { buttonScale = 1.0 }
                }
            }
            
            // Demo Login Button
            Button(action: handleDemoLogin) {
                Text(demoLoading ? "Logging in..." : "Demo Login")
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
                    .scaleEffect(demoButtonScale)
            }
            .disabled(demoLoading)
            .padding(.horizontal)
            .onTapGesture {
                withAnimation(.spring()) { demoButtonScale = 0.95 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) { demoButtonScale = 1.0 }
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
        // Combined alert
        .alert(isPresented: Binding<Bool>(
            get: { showSuccessAlert || showDemoSuccessAlert },
            set: { _ in
                showSuccessAlert = false
                showDemoSuccessAlert = false
            }
        )) {
            if showSuccessAlert {
                return Alert(
                    title: Text("Success"),
                    message: Text("OTP sent successfully"),
                    dismissButton: .default(Text("OK")) {
                        path.append(AppRoute.verifyOtp(phoneNumber: phoneNumber))
                    }
                )
            } else {
                return Alert(
                    title: Text("Success"),
                    message: Text("Demo login successful"),
                    dismissButton: .default(Text("OK")) {
                        path.append(AppRoute.testScreens)
                    }
                )
            }
        }
     
        .onAppear { 
                checkExistingToken()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    phoneFieldIsFocused = true
                }
            }
    }
    
    private func formatPhoneNumber(_ input: String) -> (formattedNumber: String, error: String?) {
        let digits = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if digits.count > 10 { return (phoneNumber, "Phone number cannot exceed 10 digits") }
        
        var formatted = ""
        for (index, digit) in digits.enumerated() {
            if index == 3 || index == 6 { formatted += "-" }
            formatted += String(digit)
        }
        
        let error = digits.count < 10 && !digits.isEmpty ? "Phone number must be 10 digits" : nil
        return (formatted, error)
    }
    
    private func isValidPhoneNumber() -> Bool {
        let digits = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return digits.count == 10
    }
    
    private func checkExistingToken() {
        // loading = true
        // Task {
        //     do {
        //         if let token = try await KeychainHelper.getToken() {
        //             let isValid = await validateToken(token)
        //             if isValid {
        //                 authStore.login(token: token)
        //                 path.append(AppRoute.userSettings)
        //             } else {
        //                 try await KeychainHelper.deleteToken()
        //             }
        //         }
        //     } catch {
        //         try? await KeychainHelper.deleteToken()
        //     }
        //     loading = false
        // }
    }
    
    private func validateToken(_ token: String) async -> Bool {
        // do {
        //     var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/validate-token")!)
        //     request.httpMethod = "GET"
        //     request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        //     let (_, response) = try await URLSession.shared.data(for: request)
        //     guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return false }
        //     return true
        // } catch {
        //     return false
        // }
        
        return true;  // Fix dummy return 
         
    }
    
    private func handleSendOTP() {
        // guard isValidPhoneNumber() else { return }
        // loading = true
        // Task {
        //     do {
        //         var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/send-otp")!)
        //         request.httpMethod = "POST"
        //         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //         let body: [String: Any] = ["phoneNumber": phoneNumber]
        //         request.httpBody = try JSONSerialization.data(withJSONObject: body)
                
        //         let (data, response) = try await URLSession.shared.data(for: request)
        //         guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        //             let errorData = try JSONDecoder().decode(ErrorResponse.self, from: data)
        //             DispatchQueue.main.async {
        //                 errorMessage = errorData.error ?? "Failed to send OTP"
        //                 loading = false
        //             }
        //             return
        //         }
                
        //         DispatchQueue.main.async {
        //             loading = false
        //             showSuccessAlert = true
        //         }
        //     } catch {
        //         DispatchQueue.main.async {
        //             errorMessage = "Failed to connect: \(error.localizedDescription)"
        //             loading = false
        //         }
        //     }
        // }
    }
    
    private func handleDemoLogin() {
        // demoLoading = true
        // errorMessage = nil
        // Task {
        //     do {
        //         var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/demo-login")!)
        //         request.httpMethod = "POST"
        //         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
        //         let (data, response) = try await URLSession.shared.data(for: request)
        //         guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        //             let errorData = try JSONDecoder().decode(ErrorResponse.self, from: data)
        //             DispatchQueue.main.async {
        //                 errorMessage = errorData.error ?? "Failed to demo login"
        //                 demoLoading = false
        //             }
        //             return
        //         }
                
        //         let responseData = try JSONDecoder().decode(VerifyOTPResponse.self, from: data)
        //         try await KeychainHelper.saveToken(responseData.token)
                
        //         DispatchQueue.main.async {
        //             authStore.login(token: responseData.token)
        //             demoLoading = false
        //             showDemoSuccessAlert = true
        //         }
        //     } catch {
        //         DispatchQueue.main.async {
        //             errorMessage = "Failed to demo login: \(error.localizedDescription)"
        //             demoLoading = false
        //         }
        //     }
        // }
    }
}


//struct SignInView_Previews: PreviewProvider {
//    @State static var path = NavigationPath()
//    static var previews: some View {
//        SignInView(path: $path)
//            .environmentObject(AuthStore())
//    }
//}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
    }
}

*/


