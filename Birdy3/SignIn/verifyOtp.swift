/*
import SwiftUI

struct VerifyOtp: View {
    let phoneNumber: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Verify OTP")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button(action: {
                print("Button 1 tapped")
            }) {
                Text("Button 1")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Button 1")

            Button(action: {
                print("Button 2 tapped")
            }) {
                Text("Button 2")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Button 2")

            Button(action: {
                print("Button 3 tapped")
            }) {
                Text("Button 3")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Button 3")

            Spacer()
        }
        .padding()
        .navigationTitle("Verify OTP")
        .background(Color.white)
        .onAppear {
            print("VerifyOtp screen initialized for phone number: \(phoneNumber ?? "none")")
        }
    }
}

struct VerifyOtp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VerifyOtp(phoneNumber: nil)
        }
    }
}
*/




import SwiftUI
import Combine

// MARK: - VerifyOtp
// Ensure this entire struct definition replaces your existing one in VerifyOtp.swift.
struct VerifyOtp: View, Hashable { // <-- Must conform to Hashable for NavigationPath
    let phoneNumber: String? // Optional String property to receive data
    
    @State private var otp: String = ""
    @State private var loading = false // Controls loading state for Verify OTP button
    @State private var resendLoading = false // Controls loading state for Resend Code button
    @State private var errorMessage: String? = nil // Displays validation or API errors
    @State private var showSuccessAlert = false // Controls visibility of the success alert
    
    // UI state for animations (scale effects for interactive feedback)
    @State private var inputScale: CGFloat = 1.0
    @State private var verifyButtonScale: CGFloat = 1.0
    @State private var resendButtonScale: CGFloat = 1.0
    
    @FocusState private var otpFieldIsFocused: Bool // Manages keyboard focus
    
    // Initializer to allow phoneNumber to be optional when creating VerifyOtp
    init(phoneNumber: String? = nil) {
        self.phoneNumber = phoneNumber
    }

    // MARK: - Hashable Conformance:
    // These two methods are essential for Hashable conformance, which also satisfies Equatable.
    // Swift can synthesize these for simple structs, but explicit definition ensures correctness.
    func hash(into hasher: inout Hasher) {
        hasher.combine(phoneNumber) // Use phoneNumber as part of the hash to distinguish instances
    }

    static func == (lhs: VerifyOtp, rhs: VerifyOtp) -> Bool {
        lhs.phoneNumber == rhs.phoneNumber // Compare instances based on their phoneNumber
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Birdy Connect")
                .font(.custom("Nunito-Bold", size: 28)) // Apply custom font
                .foregroundColor(Color.blue)
            
            Text("Enter the OTP code sent to \(phoneNumber ?? "your phone")")
                .font(.custom("Nunito-Regular", size: 16)) // Apply custom font
                .foregroundColor(Color.blue)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // OTP Input Field with Animations
            TextField("Enter OTP", text: $otp)
                .font(.custom("Nunito-Regular", size: 16)) // Apply custom font
                .keyboardType(.numberPad) // Optimize for numeric input
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
                .scaleEffect(inputScale) // Apply scale animation for tap feedback
                .focused($otpFieldIsFocused) // Bind to focus state for auto-focus
                .onTapGesture {
                    withAnimation(.spring()) {
                        inputScale = 1.05 // Slightly enlarge on tap
                    }
                }
                .onChange(of: otp) { _ in
                    errorMessage = nil // Clear error message when OTP input changes
                    // Reset scale after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring()) { inputScale = 1.0 }
                    }
                }
            
            // Error Message Display
            if let error = errorMessage {
                Text(error)
                    .font(.custom("Nunito-Regular", size: 14)) // Apply custom font
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            
            // MARK: - Verify OTP Button
            Button(action: {
                if otp.isEmpty {
                    errorMessage = "Please enter the OTP code."
                    return
                }
                loading = true // Activate loading state
                errorMessage = nil // Clear previous errors
                
                // Simulate backend call delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    loading = false // Deactivate loading state
                    showSuccessAlert = true // Show success alert
                }
            }) {
                HStack {
                    if loading {
                        ProgressView() // Show spinning indicator
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(loading ? "Verifying..." : "Verify OTP")
                }
                .font(.custom("Nunito-Bold", size: 16)) // Apply custom font
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient( // Blue gradient background
                        gradient: Gradient(colors: [Color.blue, Color(red: 59/255, green: 130/255, blue: 246/255)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .scaleEffect(verifyButtonScale) // Apply scale animation for tap feedback
            }
            .disabled(loading || otp.isEmpty) // Disable button during loading or if OTP is empty
            .padding(.horizontal)
            .onTapGesture {
                // Animate button press
                withAnimation(.spring()) { verifyButtonScale = 0.95 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) { verifyButtonScale = 1.0 }
                }
            }
            
            // MARK: - Resend OTP Button
            Button(action: {
                resendLoading = true // Activate loading state
                errorMessage = nil // Clear previous errors
                
                // Simulate backend call delay for resend
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    resendLoading = false // Deactivate loading state
                    errorMessage = "OTP resent successfully! Check your phone." // Show success message
                }
            }) {
                HStack {
                    if resendLoading {
                        ProgressView() // Show spinning indicator
                            .progressViewStyle(CircularProgressViewStyle(tint: .green)) // Green tint for resend button
                    }
                    Text(resendLoading ? "Resending..." : "Resend Code")
                }
                .font(.custom("Nunito-Regular", size: 16)) // Apply custom font
                .foregroundColor(Color.green) // Distinct color for resend button
                .scaleEffect(resendButtonScale) // Apply scale animation for tap feedback
            }
            .disabled(resendLoading) // Disable button during loading
            .onTapGesture {
                // Animate button press
                withAnimation(.spring()) { resendButtonScale = 0.95 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring()) { resendButtonScale = 1.0 }
                }
            }
            
            Spacer() // Pushes content towards the top
        }
        .onAppear {
            // Automatically focus the OTP field when the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                otpFieldIsFocused = true
            }
        }
        .padding() // Overall padding for the VStack content
        .background(
            LinearGradient( // Overall background gradient
                gradient: Gradient(colors: [
                    Color(red: 230/255, green: 240/255, blue: 250/255), // Light blue top
                    Color(red: 179/255, green: 205/255, blue: 224/255)  // Slightly darker blue bottom
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea() // Extends background to cover the entire screen
        )
        // Alert for successful OTP verification (dummy action)
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("OTP verified successfully!"),
                dismissButton: .default(Text("OK")) {
                    // This is where you'd typically navigate away from VerifyOtp.
                    // For instance, path.append(AppRoute.home) if you had a path binding here.
                }
            )
        }
    }
}

// MARK: - Preview Provider
struct VerifyOtp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VerifyOtp(phoneNumber: "+1234567890") // Provide a sample phone number for preview
        }
    }
}
