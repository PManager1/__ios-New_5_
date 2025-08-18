

// import Foundation

// enum AppRoute {
//     case verifyOtp(phoneNumber: String)
//     case testScreens
//     case userSettings
//     // Add any additional cases from the original app, e.g.:
//     case profile
//     case settings
//     case dashboard
// }
import Foundation

enum AppRoute: Hashable {
    case signIn // Add if needed from original app
    case verifyOtp(phoneNumber: String)
    case testScreens
    case userSettings
    case profile
    case settings
    case home

    // Implement Hashable conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .signIn:
            hasher.combine("signIn")
        case .verifyOtp(let phoneNumber):
            hasher.combine("verifyOtp")
            hasher.combine(phoneNumber)
        case .testScreens:
            hasher.combine("testScreens")
        case .userSettings:
            hasher.combine("userSettings")
        case .profile:
            hasher.combine("profile")
        case .settings:
            hasher.combine("settings")
        
        case .home:
            hasher.combine("home")
        }
    }

    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.signIn, .signIn):
            return true
        case (.verifyOtp(let lhsPhone), .verifyOtp(let rhsPhone)):
            return lhsPhone == rhsPhone
        case (.testScreens, .testScreens):
            return true
        case (.userSettings, .userSettings):
            return true
        case (.profile, .profile):
            return true
        case (.settings, .settings):
            return true
        
        case (.home, .home):
            return true            
        default:
            return false
        }
    }
}