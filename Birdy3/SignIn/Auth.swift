// import Foundation
// import SwiftUI
// import Combine

// struct ErrorResponse: Codable {
//     let error: String?
// }

// struct VerifyOTPResponse: Codable {
//     let token: String
// }

// class KeychainHelper {
//     static func saveToken(_ token: String) async throws {
//         let data = Data(token.utf8)
//         let query: [String: Any] = [
//             kSecClass as String: kSecClassGenericPassword,
//             kSecAttrService as String: "com.yourapp.birdy",
//             kSecAttrAccount as String: "authToken",
//             kSecValueData as String: data
//         ]
        
//         SecItemDelete(query as CFDictionary)
//         let status = SecItemAdd(query as CFDictionary, nil)
//         guard status == errSecSuccess else {
//             throw NSError(domain: "KeychainError", code: Int(status), userInfo: nil)
//         }
//     }
    
//     static func getToken() async throws -> String? {
//         let query: [String: Any] = [
//             kSecClass as String: kSecClassGenericPassword,
//             kSecAttrService as String: "com.yourapp.birdy",
//             kSecAttrAccount as String: "authToken",
//             kSecReturnData as String: true,
//             kSecMatchLimit as String: kSecMatchLimitOne
//         ]
        
//         var item: CFTypeRef?
//         let status = SecItemCopyMatching(query as CFDictionary, &item)
//         guard status == errSecSuccess, let data = item as? Data else {
//             return nil
//         }
//         return String(data: data, encoding: .utf8)
//     }
    
//     static func deleteToken() async throws {
//         let query: [String: Any] = [
//             kSecClass as String: kSecClassGenericPassword,
//             kSecAttrService as String: "com.yourapp.birdy",
//             kSecAttrAccount as String: "authToken"
//         ]
//         SecItemDelete(query as CFDictionary)
//     }
// }

// class AuthStore: ObservableObject {
//     @Published var isLoggedIn: Bool = false
//     @Published var token: String?
//     @Published var user: User?

//     func login(token: String) {
//         self.token = token
//         self.isLoggedIn = true
//         // Additional login logic, e.g., fetch user data
//     }
    
//     func logout() {
//         self.token = nil
//         self.isLoggedIn = false
//         self.user = nil
//         Task {
//             try? await KeychainHelper.deleteToken()
//         }
//     }

//     func updateUserField(key: String, value: String) {
//         if key == "referralCode" {
//             user?.referralCode = value
//         }
//     }
// }

// struct User {
//     var referralCode: String?
// }


/*
import Foundation

class AuthViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var showOTPView: Bool = false
    @Published var isAuthenticated: Bool = false
    
    private let keychainManager: KeychainManager
    
    init(keychainManager: KeychainManager = KeychainManager()) {
        self.keychainManager = keychainManager
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        if keychainManager.getToken() != nil {
            isAuthenticated = true
        }
    }
    
    func navigateToSignIn() {
        phoneNumber = ""
        showOTPView = false
        isAuthenticated = false
        showError = false
        errorMessage = nil
    }
    
    func sendOTP(phoneNumber: String) async {
        self.phoneNumber = phoneNumber
        await performAsync {
            let urlString = Config.apiBaseURL + "auth/send-otp"
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: String] = ["phoneNumber": phoneNumber]
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let message = json?["message"] as? String ?? "Failed to send OTP"
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            }
            
            showOTPView = true
        }
    }
    
    func verifyOTP(otp: String) async {
        await performAsync {
            let urlString = Config.apiBaseURL + "auth/validate-token"
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: String] = ["otp": otp, "phoneNumber": phoneNumber]
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let message = json?["message"] as? String ?? "Invalid OTP"
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let token = json["token"] as? String else {
                let message = json["message"] as? String ?? "Invalid OTP"
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            }
            
            try keychainManager.saveToken(token)
            isAuthenticated = true
        }
    }
    
    func resendOTP() async {
        await performAsync {
            let urlString = Config.apiBaseURL + "auth/send-otp"
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: String] = ["phoneNumber": phoneNumber]
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let message = json?["message"] as? String ?? "Failed to resend OTP"
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            }
        }
    }
    
    private func performAsync(_ operation: @escaping () async throws -> Void) async {
        isLoading = true
        showError = false
        errorMessage = nil
        do {
            try await operation()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
*/