import SwiftUI

struct SignInView: View {
    @Binding var path: NavigationPath
    @State private var phoneNumber: String = ""
    @State private var loading = false
    @State private var demoLoading = false
    @State private var errorMessage: String?
    @State private var inputScale: CGFloat = 1.0
    @State private var buttonScale: CGFloat = 1.0
    @State private var demoButtonScale: CGFloat = 1.0
    @FocusState private var phoneFieldIsFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In to Birdy")
                .font(.custom("Nunito-Bold", size: 28))
                .foregroundColor(.blue)

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
                    .focused($phoneFieldIsFocused)
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

            if loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .accessibilityLabel("Loading")
            } else {
                Button(action: {
                    loading = true
                    withAnimation(.spring()) { buttonScale = 0.95 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring()) { buttonScale = 1.0 }
                    }
                    handleSendOTP()
                }) {
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
                .accessibilityLabel("Send OTP")
            }

            if demoLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .accessibilityLabel("Loading")
            } else {
                Button(action: {
                    demoLoading = true
                    withAnimation(.spring()) { demoButtonScale = 0.95 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring()) { demoButtonScale = 1.0 }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        demoLoading = false
                        print("Demo Login tapped")
                    }
                }) {
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
                .accessibilityLabel("Demo Login")
            }

            Button(action: {
                print("Extra Action tapped")
            }) {
                Text("Extra Action")
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
            }
            .padding(.horizontal)
            .accessibilityLabel("Extra Action")

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

    private func handleSendOTP() {
        guard isValidPhoneNumber() else { return }
        loading = true
        Task {
            do {
                var request = URLRequest(url: URL(string: "\(Config.apiBaseURL)auth/send-otp")!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let body: [String: Any] = ["phoneNumber": phoneNumber]
                request.httpBody = try JSONSerialization.data(withJSONObject: body)

                let (_, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        errorMessage = "Failed to send OTP"
                        loading = false
                    }
                    return
                }

                DispatchQueue.main.async {
                    loading = false
                    path.append(AppRoute.verifyOtp(phoneNumber: phoneNumber))
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to connect: \(error.localizedDescription)"
                    loading = false
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView(path: .constant(NavigationPath()))
        }
    }
}