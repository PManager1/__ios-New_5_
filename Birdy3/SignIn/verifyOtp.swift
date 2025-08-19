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