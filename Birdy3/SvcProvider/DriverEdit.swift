//import SwiftUI
//
//struct DriverEdit: View {
//    @Environment(\.dismiss) private var dismiss  // For back navigation
//    @State private var bio: String = ""
//    @State private var bioInput: String = ""
//    @State private var isBioModalVisible: Bool = false
//    @FocusState private var bioFocused: Bool  // Changed to @FocusState
//    
//    @State private var apple: String = ""
//    @State private var venmo: String = ""
//    @State private var paypal: String = ""
//    @State private var kashapp: String = ""
//    @State private var zelle: String = ""
//    
//    @FocusState private var appleFocused: Bool  // Changed to @FocusState
//    @FocusState private var venmoFocused: Bool
//    @FocusState private var paypalFocused: Bool
//    @FocusState private var kashappFocused: Bool
//    @FocusState private var zelleFocused: Bool
//    
//    @State private var selectedServices: [String] = []
//    @State private var isModalVisible: Bool = false
//    let servicesList: [String] = ["Service 1", "Service 2", "Service 3"]  // Replace with actual services
//    
//    @State private var buttonScale: CGFloat = 1.0  // For button press animation
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [Color(hex: "#4B0082"), Color(hex: "#00B7EB")]), startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
//            
//            VStack {
//                HStack {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.white)
//                            .font(.system(size: 24))
//                    }
//                    .padding(.leading, 20)
//                    .padding(.top, 40)
//                    Spacer()
//                }
//                
//                ScrollView {
//                    VStack(alignment: .center, spacing: 20) {
//                        Text("Driver Profile")
//                            .font(.custom("Nunito-Bold", size: 28))
//                            .foregroundColor(.white)
//                        
//                        Text("Information for your Riders")
//                            .font(.custom("Nunito-SemiBold", size: 20))
//                            .foregroundColor(.white)
//                        
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("Bio")
//                                .font(.custom("Nunito-SemiBold", size: 16))
//                                .foregroundColor(.white)
//                            
//                            Button(action: {
//                                bioInput = bio
//                                isBioModalVisible = true
//                            }) {
//                                Text(bio.isEmpty ? "Tap to add a bio" : bio)
//                                    .font(.custom("Nunito-Regular", size: 16))
//                                    .foregroundColor(.black)
//                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 200, alignment: .center)
//                                    .padding(15)
//                                    .background(Color.white)
//                                    .cornerRadius(10)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .stroke(bioFocused ? Color(hex: "#00B7EB") : Color.gray.opacity(0.2), lineWidth: 1)
//                                    )
//                                    .shadow(color: bioFocused ? Color(hex: "#00B7EB").opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
//                            }
//                            // Remove .onHover (macOS only) and handle focus some other way if needed
//                        }
//                        .frame(width: UIScreen.main.bounds.width * 0.9)
//                        
//                        Text("Payment Methods")
//                            .font(.custom("Nunito-SemiBold", size: 20))
//                            .foregroundColor(.white)
//                        
//                        VStack(spacing: 10) {
//                            HStack(spacing: 10) {
//                                paymentField(icon: "dollarsign.circle", placeholder: "Apple Username", text: $apple, focused: $appleFocused, keyboardType: .default)
//                                paymentField(icon: "dollarsign.circle", placeholder: "Venmo Username", text: $venmo, focused: $venmoFocused, keyboardType: .default)
//                            }
//                            HStack(spacing: 10) {
//                                paymentField(icon: "dollarsign.circle", placeholder: "PayPal Email", text: $paypal, focused: $paypalFocused, keyboardType: .emailAddress)
//                            }
//                            HStack(spacing: 10) {
//                                paymentField(icon: "dollarsign.circle", placeholder: "Cashapp Username", text: $kashapp, focused: $kashappFocused, keyboardType: .default)
//                                paymentField(icon: "dollarsign.circle", placeholder: "Zelle Email/Phone", text: $zelle, focused: $zelleFocused, keyboardType: .emailAddress)
//                            }
//                        }
//                        .frame(width: UIScreen.main.bounds.width * 0.9)
//                        
//                        Text("Services")
//                            .font(.custom("Nunito-SemiBold", size: 20))
//                            .foregroundColor(.white)
//                        
//                        Button(action: {
//                            isModalVisible = true
//                        }) {
//                            Text("Select Services")
//                                .font(.custom("Nunito-SemiBold", size: 18))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 15)
//                                .background(Color(hex: "#00B7EB"))
//                                .cornerRadius(10)
//                        }
//                        .frame(width: UIScreen.main.bounds.width * 0.9)
//                        
//                        Text("Selected Services: \(selectedServices.isEmpty ? "None" : selectedServices.joined(separator: ", "))")
//                            .font(.custom("Nunito-Regular", size: 16))
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.center)
//                        
//                        Button(action: {
//                            handleUpdate()
//                        }) {
//                            Text("Save")
//                                .font(.custom("Nunito-SemiBold", size: 18))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 15)
//                                .background(Color(hex: "#00B7EB"))
//                                .cornerRadius(10)
//                        }
//                        .scaleEffect(buttonScale)
//                        .gesture(
//                            DragGesture(minimumDistance: 0)
//                                .onChanged { _ in withAnimation { buttonScale = 0.95 } }
//                                .onEnded { _ in withAnimation { buttonScale = 1.0 } }
//                        )
//                        .frame(width: UIScreen.main.bounds.width * 0.9)
//                        
//                        NavigationLink(destination: VehicleInfo()) {
//                            Text("Vehicle Information ➡️")
//                                .font(.custom("Nunito-SemiBold", size: 18))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 15)
//                                .background(Color(hex: "#00B7EB"))
//                                .cornerRadius(10)
//                        }
//                        .scaleEffect(buttonScale)
//                        .gesture(
//                            DragGesture(minimumDistance: 0)
//                                .onChanged { _ in withAnimation { buttonScale = 0.95 } }
//                                .onEnded { _ in withAnimation { buttonScale = 1.0 } }
//                        )
//                        .frame(width: UIScreen.main.bounds.width * 0.9)
//                    }
//                    .padding(.top, 80)
//                    .padding(.bottom, 20)
//                }
//                .ignoresSafeArea(.keyboard)
//            }
//        }
//        .sheet(isPresented: $isBioModalVisible) { bioModal }
//        .sheet(isPresented: $isModalVisible) { servicesModal }
//    }
//    
//    private var bioModal: some View {
//        LinearGradient(gradient: Gradient(colors: [Color(hex: "#E0F2FE"), Color(hex: "#BAE6FD")]), startPoint: .top, endPoint: .bottom)
//            .ignoresSafeArea()
//            .overlay(
//                VStack(spacing: 20) {
//                    Text("Edit Bio")
//                        .font(.custom("Nunito-Bold", size: 20))
//                        .foregroundColor(Color(hex: "#1E3A8A"))
//                    
//                    TextEditor(text: $bioInput)
//                        .frame(minHeight: 100, maxHeight: 200)
//                        .padding(15)
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//                        )
//                        .font(.custom("Nunito-Regular", size: 16))
//                    
//                    HStack(spacing: 20) {
//                        Button("Cancel") {
//                            isBioModalVisible = false
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(Color(hex: "#1E3A8A"))
//                        .cornerRadius(10)
//                        .foregroundColor(.white)
//                        .font(.custom("Nunito-SemiBold", size: 16))
//                        
//                        Button("Save") {
//                            bio = bioInput
//                            isBioModalVisible = false
//                            print("Bio updated to: \(bio)")
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(Color(hex: "#1E3A8A"))
//                        .cornerRadius(10)
//                        .foregroundColor(.white)
//                        .font(.custom("Nunito-SemiBold", size: 16))
//                    }
//                }
//                .padding(20)
//                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
//            )
//    }
//    
//    private var servicesModal: some View {
//        LinearGradient(gradient: Gradient(colors: [Color(hex: "#E0F2FE"), Color(hex: "#BAE6FD")]), startPoint: .top, endPoint: .bottom)
//            .ignoresSafeArea()
//            .overlay(
//                VStack(spacing: 20) {
//                    Text("Select Services")
//                        .font(.custom("Nunito-Bold", size: 20))
//                        .foregroundColor(Color(hex: "#1E3A8A"))
//                    
//                    List(servicesList, id: \.self) { service in
//                        Button(action: {
//                            toggleService(service)
//                        }) {
//                            HStack {
//                                Text(service)
//                                    .font(.custom("Nunito-Regular", size: 16))
//                                    .foregroundColor(.black)
//                                Spacer()
//                                if selectedServices.contains(service) {
//                                    Image(systemName: "checkmark.circle")
//                                        .foregroundColor(Color(hex: "#1E3A8A"))
//                                        .font(.system(size: 20))
//                                }
//                            }
//                        }
//                    }
//                    
//                    Button("Done") {
//                        isModalVisible = false
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 12)
//                    .background(Color(hex: "#1E3A8A"))
//                    .cornerRadius(10)
//                    .foregroundColor(.white)
//                    .font(.custom("Nunito-SemiBold", size: 16))
//                }
//                .padding(20)
//                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
//            )
//    }
//    
//    private func paymentField(icon: String, placeholder: String, text: Binding<String>, focused: FocusState<Bool>.Binding, keyboardType: UIKeyboardType) -> some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(.gray)
//                .font(.system(size: 20))
//                .padding(.trailing, 5)
//            
//            TextField(placeholder, text: text)
//                .font(.custom("Nunito-Regular", size: 16))
//                .foregroundColor(.black)
//                .padding(15)
//                .background(Color.white)
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(focused.wrappedValue ? Color(hex: "#00B7EB") : Color.gray.opacity(0.2), lineWidth: 1)
//                )
//                .shadow(color: focused.wrappedValue ? Color(hex: "#00B7EB").opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
//                .keyboardType(keyboardType)
//                .autocapitalization(.none)
//                .focused(focused)
//        }
//    }
//    
//    private func toggleService(_ service: String) {
//        if selectedServices.contains(service) {
//            selectedServices.removeAll { $0 == service }
//        } else {
//            selectedServices.append(service)
//        }
//    }
//    
//    private func handleUpdate() {
//        print("Updating profile...")
//    }
//}
//
//// Color extension for hex input
//// extension Color {
////     init(hex: String) {
////         let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
////         var int: UInt64 = 0
////         Scanner(string: hex).scanHexInt64(&int)
////         let a, r, g, b: UInt64
////         switch hex.count {
////         case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
////         case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
////         case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
////         default: (a, r, g, b) = (1, 1, 1, 0)
////         }
////         self.init(
////             .sRGB,
////             red: Double(r) / 255,
////             green: Double(g) / 255,
////             blue: Double(b) / 255,
////             opacity: Double(a) / 255
////         )
////     }
//// }
//
//// Preview
//#Preview {
//    NavigationStack {
//        DriverEdit()
//    }
//}
