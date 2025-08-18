
import SwiftUI

struct AddClient: View {
    // State for input fields
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var buttonScale: CGFloat = 1.0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Input Card
                    VStack(spacing: 8) {
                        Text("Add Client")
                            .font(.custom("Nunito-Bold", size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Email Input
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Email Address")
                                .font(.custom("Nunito-SemiBold", size: 12))
                                .foregroundColor(.gray)

                            TextField("Enter email address", text: $email)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }

                        // Phone Number Input
                        VStack(alignment: .leading, spacing: 4) {
                            Text("OR Phone Number")
                                .font(.custom("Nunito-SemiBold", size: 12))
                                .foregroundColor(.gray)

                            TextField("Enter phone number", text: $phoneNumber)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .keyboardType(.phonePad)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                    // Dummy QR Code Card
                    VStack(spacing: 8) {
                        Text("Client QR Code")
                            .font(.custom("Nunito-Bold", size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Placeholder for QR Code
                        Image(systemName: "qrcode")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        Text("Placeholder QR Code")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                    // Add to List Button
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.15)) {
                            buttonScale = 0.98
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                buttonScale = 1.0
                                print("Add to List tapped: email=\(email), phoneNumber=\(phoneNumber)")
                            }
                        }
                    }) {
                        Text("Add to List")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .scaleEffect(buttonScale)
                    .padding(.horizontal)
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("Add Client")
        }
    }
}

struct AddClient_Previews: PreviewProvider {
    static var previews: some View {
        AddClient()
    }
}
