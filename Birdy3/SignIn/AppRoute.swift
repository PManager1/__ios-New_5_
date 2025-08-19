import Foundation

enum AppRoute: Hashable {
    case signIn
    case verifyOtp(phoneNumber: String?)
}