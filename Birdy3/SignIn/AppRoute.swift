

import Foundation

enum AppRoute: Hashable {
    case home
    case signIn
    case verifyOtp(phoneNumber: String?)
    case NewView
}