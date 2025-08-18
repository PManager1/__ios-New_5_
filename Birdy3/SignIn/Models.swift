import Foundation

struct ErrorResponse: Codable {
    let error: String?
}

struct VerifyOTPResponse: Codable {
    let token: String
}

class KeychainHelper {
    static func saveToken(_ token: String) async throws {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.yourapp.birdy",
            kSecAttrAccount as String: "authToken",
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: nil)
        }
    }
    
    static func getToken() async throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.yourapp.birdy",
            kSecAttrAccount as String: "authToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    static func deleteToken() async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.yourapp.birdy",
            kSecAttrAccount as String: "authToken"
        ]
        SecItemDelete(query as CFDictionary)
    }
}

class AuthStore: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var token: String?
    
    init() {
        Task {
            if let token = try? await KeychainHelper.getToken() {
                self.token = token
                self.isLoggedIn = true
                do {
                    try await verifyLogin()
                } catch {
                    await MainActor.run {
                        self.logout()
                    }
                }
            }
        }
    }
    
    func login(token: String) async {
        self.token = token
        self.isLoggedIn = true
        try? await KeychainHelper.saveToken(token)
    }
    
    func logout() {
        self.token = nil
        self.isLoggedIn = false
        Task {
            try? await KeychainHelper.deleteToken()
        }
    }
    
    func verifyLogin() async throws {
        guard let token = token else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No token"])
        }
        let url = URL(string: "\(Config.apiBaseURL)auth/verify")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorData = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorData.error ?? "Token verification failed"])
        }
    }
}