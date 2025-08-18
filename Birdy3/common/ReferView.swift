/*
import SwiftUI

struct ReferView: View {
    @Binding var path: NavigationPath
    @State private var email: String = ""
    @State private var referrals: Int = 10
    @State private var isModalVisible: Bool = false
    @State private var newReferralCode: String = ""
    @State private var isSaving: Bool = false
    @State private var referralCode: String = "defaultcode"
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""

    // Animation states
    @State private var qrScale: CGFloat = 0.8
    @State private var qrOpacity: Double = 0
    @State private var sectionOpacities: [String: Double] = [
        "header": 0, "qr": 0, "share": 0, "email": 0,
        "stats": 0, "progress": 0, "changeCode": 0
    ]
    @State private var statCardOpacities: [Double] = [0, 0, 0]
    @State private var progressWidth: Double = 0
    @State private var modalOpacity: Double = 0

    private let cardWidth: CGFloat = 350

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#1E3A8A"), Color(hex: "#3B82F6")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Menu Button
            HStack {
                SwiftUI.Button {
                    path.append(AppRoute.testScreens)
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.top, 40)
            .padding(.leading, 20)

            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    VStack(spacing: 8)
                        .opacity(sectionOpacities["header"] ?? 0)
                        .offset(y: sectionOpacities["header"] == 1 ? 0 : 20)
                        .animation(.easeInOut(duration: 0.4).delay(0.1), value: sectionOpacities["header"])
                    {
                        Text("Invite Riders & Drivers")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("Share your referral code and keep more profit next week!")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#D1D5DB"))
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: cardWidth)

                    // QR Code & Referral Code Section
                    VStack(spacing: 12)
                        .opacity(sectionOpacities["qr"] ?? 0)
                        .offset(y: sectionOpacities["qr"] == 1 ? 0 : 20)
                        .animation(.easeInOut(duration: 0.4).delay(0.2), value: sectionOpacities["qr"])
                    {
                        Text("Your Referral Code")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        ZStack {
                            if !referralCode.isEmpty {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                                    .frame(width: 200, height: 200)
                                    .scaleEffect(qrScale)
                                    .opacity(qrOpacity)
                                    .animation(.spring(response: 0.6), value: qrScale)
                                    .overlay(
                                        Text("QR: \(referralCode)")
                                            .foregroundColor(.black)
                                            .font(.caption)
                                    )
                            } else {
                                Text("No referral code available")
                                    .foregroundColor(.black)
                            }
                        }
                        Text(referralCode)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.black)
                    }
                    .padding(20)
                    .background(.white)
                    .cornerRadius(20)
                    .frame(width: cardWidth)

                    // Share Options Section
                    VStack(spacing: 8)
                        .opacity(sectionOpacities["share"] ?? 0)
                        .offset(y: sectionOpacities["share"] == 1 ? 0 : 20)
                        .animation(.easeInOut(duration: 0.4).delay(0.3), value: sectionOpacities["share"])
                    {
                        Text("Share Your Code")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        SwiftUI.Button {
                            handleShareQR()
                        } label: {
                            Label("Share QR Code", systemImage: "qrcode")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .background(Color(hex: "#3498db"))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                        SwiftUI.Button {
                            handleShareSocial()
                        } label: {
                            Label("Share via Social Media", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .background(Color(hex: "#3498db"))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                        SwiftUI.Button {
                            handleCopyCode()
                        } label: {
                            Label("Copy Code", systemImage: "doc.on.doc")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .background(Color(hex: "#3498db"))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .frame(width: cardWidth)

                    // Email Invite Section
                    VStack(spacing: 8)
                        .opacity(sectionOpacities["email"] ?? 0)
                        .offset(y: sectionOpacities["email"] == 1 ? 0 : 20)
                        .animation(.easeInOut(duration: 0.4).delay(0.4), value: sectionOpacities["email"])
                    {
                        Text("Invite via Email")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        HStack {
                            TextField("Enter email address", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 15)
                                .background(.white)
                                .cornerRadius(15)
                            SwiftUI.Button {
                                handleSendLink()
                            } label: {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .padding(15)
                                    .background(Color(hex: "#3498db"))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .frame(width: cardWidth)

                    // Referral Stats Section
                    VStack(spacing: 12)
                        .opacity(sectionOpacities["stats"] ?? 0)
                        .offset(y: sectionOpacities["stats"] == 1 ? 0 : 20)
                        .animation(.easeInOut(duration: 0.4).delay(0.5), value: sectionOpacities["stats"])
                    {
                        Text("Your Referral Stats")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach([
                                ("Referrals Sent", "25"),
                                ("Successful Referrals", "\(referrals)"),
                                ("Your service charge", "80% 20%")
                            ], id: \.0) { stat, value in
                                VStack {
                                    Text(value)
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    Text(stat)
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "#D1D5DB"))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: (cardWidth - 20) / 2)
                                .padding(15)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(15)
                            }
                        }
                    }
                    .frame(width: cardWidth)

                    // Referral Progress Section
                    VStack(spacing: 10)
                        .opacity(sectionOpacities["progress"] ?? 0)
                        .offset(y: sectionOpacities["progress"] == 1 ? 0 : 20)
                        .animation(.easeInOut(duration: 0.4).delay(0.6), value: sectionOpacities["progress"])
                    {
                        Text("Referral Goal Progress")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        Text("\(referrals) of 15 referrals to keep \(getProfitPercentage()) of the profit with no cut to anyone")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#D1D5DB"))
                            .multilineTextAlignment(.center)
                        Text("\(daysUntilEndOfWeek()) days left until the end of the week")
                            .font(.caption)
                            .foregroundColor(.white)
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 10)
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(hex: "#34C759"))
                                .frame(width: cardWidth * CGFloat(progressWidth / 100), height: 10)
                                .animation(.easeInOut(duration: 0.8), value: progressWidth)
                        }
                        Text(progressText)
                            .font(.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: cardWidth)

                    // Change Referral Code Section
                    VStack
                        .opacity(sectionOpacities["changeCode"] ?? 0)
                        .offset(y: sectionOpacities["changeCode"] == 1 ? 0 : 20)
                        .animation(.easeInOut(duration: 0.4).delay(0.7), value: sectionOpacities["changeCode"])
                    {
                        Text("Change Your Referral Code")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                        SwiftUI.Button {
                            handleChangeCode()
                        } label: {
                            Label("Change Referral Code", systemImage: "pencil")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .background(Color(hex: "#3498db"))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .frame(width: cardWidth)
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .overlay {
            if isModalVisible {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .opacity(modalOpacity)
                    .animation(.easeInOut(duration: 0.3), value: modalOpacity)
                VStack(spacing: 20) {
                    Text("Enter New Referral Code")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.black)
                    TextField("Enter new code", text: $newReferralCode)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.characters)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(Color(hex: "#f5f5f5"))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .frame(height: 50)
                    HStack(spacing: 10) {
                        SwiftUI.Button {
                            handleCancelCodeChange()
                        } label: {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.gray)
                                .cornerRadius(15)
                        }
                        .disabled(isSaving)
                        SwiftUI.Button {
                            handleSaveCode()
                        } label: {
                            if isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Save")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(isSaving ? Color.gray : Color(hex: "#34C759"))
                        .cornerRadius(15)
                        .disabled(isSaving)
                    }
                }
                .padding(20)
                .background(.white)
                .cornerRadius(20)
                .frame(width: cardWidth)
                .opacity(modalOpacity)
                .animation(.easeInOut(duration: 0.3), value: modalOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6)) {
                qrScale = 1
                qrOpacity = 1
            }
            sectionOpacities.keys.forEach { key in
                let delay = (sectionOpacities.keys.firstIndex(of: key)! + 1) * 0.1
                withAnimation(.easeInOut(duration: 0.4).delay(delay)) {
                    sectionOpacities[key] = 1
                }
            }
            statCardOpacities.enumerated().forEach { index, _ in
                withAnimation(.easeInOut(duration: 0.3).delay(0.6 + Double(index) * 0.1)) {
                    statCardOpacities[index] = 1
                }
            }
            let maxReferrals = 15
            let progress = min(Double(referrals) / Double(maxReferrals) * 100, 100)
            withAnimation(.easeInOut(duration: 0.8)) {
                progressWidth = progress
            }
        }
    }

    private func handleShareQR() {
        let url = "https://example.com/refer?code=\(referralCode)"
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    private func handleShareSocial() {
        let message = "Join as a rider/driver with my referral code: \(referralCode)\nhttps://example.com/refer?code=\(referralCode)"
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    private func handleCopyCode() {
        UIPasteboard.general.string = referralCode
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        alertTitle = "Success"
        alertMessage = "Referral code copied to clipboard!"
        showAlert = true
    }

    private func handleSendLink() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        if !email.matches(emailRegex) {
            alertTitle = "Error"
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        let message = "Join as a rider/driver with my referral code: \(referralCode)\nhttps://example.com/refer?code=\(referralCode)"
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true) {
            email = ""
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            alertTitle = "Success"
            alertMessage = "Referral link sent!"
            showAlert = true
        }
    }

    private func handleChangeCode() {
        isModalVisible = true
        withAnimation(.easeInOut(duration: 0.3)) {
            modalOpacity = 1
        }
    }

    private func handleSaveCode() {
        if newReferralCode.count < 4 {
            alertTitle = "Error"
            alertMessage = "Referral code must be at least 4 characters"
            showAlert = true
            return
        }
        isSaving = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            referralCode = newReferralCode
            isModalVisible = false
            newReferralCode = ""
            isSaving = false
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            alertTitle = "Success"
            alertMessage = "Referral code updated!"
            showAlert = true
            withAnimation(.easeInOut(duration: 0.3)) {
                modalOpacity = 0
            }
        }
    }

    private func handleCancelCodeChange() {
        isModalVisible = false
        newReferralCode = ""
        withAnimation(.easeInOut(duration: 0.3)) {
            modalOpacity = 0
        }
    }

    private func getProfitPercentage() -> String {
        if referrals >= 15 { return "100%" }
        if referrals >= 10 { return "90%" }
        return "80%"
    }

    private func daysUntilEndOfWeek() -> Int {
        let today = Date()
        let calendar = Calendar.current
        let endOfWeek = calendar.date(from: calendar.dateComponents([.year, .weekOfYear], from: calendar.date(byAdding: .day, value: 7 - calendar.component(.weekday, from: today), to: today)!))!
        let diff = calendar.dateComponents([.day], from: today, to: endOfWeek)
        return diff.day ?? 0
    }

    private var progressText: String {
        if referrals < 10 {
            return "\(10 - referrals) more referrals to keep 90% of the profit"
        } else if referrals < 15 {
            return "Complete \(15 - referrals) more referrals to unlock 5% service charges for the upcoming week!"
        } else {
            return "You keep all the profit!"
        }
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
}

struct ReferView_Previews: PreviewProvider {
    @State static var path = NavigationPath()

    static var previews: some View {
        ReferView(path: $path)
    }
}
*/