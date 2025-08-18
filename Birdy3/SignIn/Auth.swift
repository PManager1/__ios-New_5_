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