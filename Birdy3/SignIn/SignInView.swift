import SwiftUI

struct SignInView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button(action: {
                path.append(AppRoute.verifyOtp(phoneNumber: nil))
            }) {
                Text("Go to OTP")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Go to OTP")

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
        .navigationTitle("Sign In")
        .background(Color.white)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView(path: .constant(NavigationPath()))
        }
    }
}