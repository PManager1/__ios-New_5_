import SwiftUI

// System rates constants
struct SystemRates {
    static let minFare: Double = 5.0
    static let baseFare: Double = 2.5
    static let perMinute: Double = 0.3
    static let perMile: Double = 1.5
    static let surge: Double = 0.0
}

struct RateCardView: View {
    // State for custom rate inputs and rate type selection
    @State private var customMinFare: String = ""
    @State private var customBaseFare: String = ""
    @State private var customPerMinute: String = ""
    @State private var customPerMile: String = ""
    @State private var customSurge: String = ""
    @State private var selectedRateType: String = "System" // "System" or "Custom"
    @State private var buttonScale: CGFloat = 1.0

    // Rate fields and labels
    private let rateFields: [(key: String, label: String)] = [
        ("minFare", "Min Fare"),
        ("baseFare", "Base Fare"),
        ("perMinute", "Per Minute"),
        ("perMile", "Per Mile"),
        ("surge", "Surge")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // System Rate Card Display
                    VStack(spacing: 10) {
                        Text("System Rates")
                            .font(.custom("Nunito-Bold", size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Min Fare: $\(String(format: "%.2f", SystemRates.minFare))")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Base Fare: $\(String(format: "%.2f", SystemRates.baseFare))")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Per Minute: $\(String(format: "%.2f", SystemRates.perMinute))")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Per Mile: $\(String(format: "%.2f", SystemRates.perMile))")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Surge: \(String(format: "%.2f", SystemRates.surge))x")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                    // Custom Rates Input Card
                    VStack(spacing: 8) {
                        Text("Custom Rates")
                            .font(.custom("Nunito-Bold", size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(rateFields, id: \.key) { field in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(field.label)
                                    .font(.custom("Nunito-SemiBold", size: 12))
                                    .foregroundColor(.gray)

                                TextField("Enter \(field.label.lowercased())", text: binding(for: field.key))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .keyboardType(.decimalPad)
                                    .disabled(selectedRateType == "System")
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                    // Save Button (shown only for Custom rates)
                    if selectedRateType == "Custom" {
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.15)) {
                                buttonScale = 0.98
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    buttonScale = 1.0
                                    print("Save tapped: minFare=\(customMinFare), baseFare=\(customBaseFare), perMinute=\(customPerMinute), perMile=\(customPerMile), surge=\(customSurge)")
                                }
                            }
                        }) {
                            Text("Save Rates")
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
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("Rate Card -2")
            .font(.custom("Nunito-SemiBold", size: 14))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Rate Type", selection: $selectedRateType) {
                        Text("System").tag("System")
                        Text("Custom").tag("Custom")
                    }
                    .pickerStyle(.segmented)
                    .font(.custom("Nunito-Regular", size: 14))
                }
            }
        }
    }

    // Helper function to get binding for TextField
    private func binding(for key: String) -> Binding<String> {
        switch key {
        case "minFare":
            return $customMinFare
        case "baseFare":
            return $customBaseFare
        case "perMinute":
            return $customPerMinute
        case "perMile":
            return $customPerMile
        case "surge":
            return $customSurge
        default:
            return .constant("")
        }
    }
}

struct RateCardView_Previews: PreviewProvider {
    static var previews: some View {
        RateCardView()
    }
}
