// import SwiftUI
// import UIKit

// struct DriverDetail: View {
//     @State private var feedbackMessage = ""
//     @State private var activeButton: String? = nil
//     @State private var copyMessage = ""
    
//     let driverImageURL = URL(string: "https://randomuser.me/api/portraits/men/1.jpg")
    
//     // Payment options data
//     let payments = [
//         PaymentOption(name: "Venmo", handle: "@YourVenmoHandle", logoName: "venmo"),
//         PaymentOption(name: "Zelle", handle: "youremail@example.com", logoName: "Zelle"),
//         PaymentOption(name: "PayPal", handle: "youremail@example.com", logoName: "PayPal"),
//         PaymentOption(name: "Cash App", handle: "$YourCashtag", logoName: "cashapp")
//     ]
    
//     // Work schedule data
//     let schedule = [
//         WorkSchedule(day: "Monday - Friday", hours: "7:00 AM - 7:00 PM"),
//         WorkSchedule(day: "Saturday", hours: "9:00 AM - 5:00 PM"),
//         WorkSchedule(day: "Sunday", hours: "10:00 AM - 4:00 PM")
//     ]
    
//     // Testimonials data
//     let testimonials = [
//         Testimonial(quote: "John is the most courteous and punctual driver I've ever had!", author: "Emily S."),
//         Testimonial(quote: "Always a pleasure to ride with John. He makes every trip enjoyable!", author: "Michael T."),
//         Testimonial(quote: "John's professionalism and friendly attitude are top-notch!", author: "Lisa R.")
//     ]
    
//     // Photos data
//     let photos = [
//         Photo(uri: "https://fastly.picsum.photos/id/15/2500/1667.jpg?hmac=Lv03D1Y3AsZ9L2tMMC1KQZekBVaQSDc1waqJ54IHvo4", title: "Summer Vacation"),
//         Photo(uri: "https://picsum.photos/300/200?random=2", title: "Holiday Gathering"),
//         Photo(uri: "https://fastly.picsum.photos/id/237/536/354.jpg?hmac=i0yVXW1ORpyCZpQ-CknuyV-jbtU7_x9EBQVhvT5aRr0", title: "My Buddy")
//     ]
    
//     var body: some View {
//         ScrollView {
//             VStack(spacing: 24) {
//                 // MARK: Header
//                 headerSection
                
//                 // MARK: Profile Image & About
//                 profileSection
                
//                 // MARK: Feedback Buttons
//                 feedbackButtons
                
//                 // MARK: Feedback Message
//                 if !feedbackMessage.isEmpty {
//                     Text(feedbackMessage)
//                         .font(.custom("Nunito", size: 16))
//                         .foregroundColor(.green)
//                         .transition(.opacity)
//                 }
                
//                 // MARK: Contact Buttons
//                 contactButtons
                
//                 Divider().padding(.vertical)
                
//                 // MARK: Payment Options
//                 paymentOptionsSection
                
//                 Divider().padding(.vertical)
                
//                 // MARK: Working Hours
//                 workingHoursSection
                
//                 Divider().padding(.vertical)
                
//                 // MARK: Photos swiper
//                 photosSwiperSection
                
//                 Divider().padding(.vertical)
                
//                 // MARK: Testimonials
//                 testimonialsSection
                
//                 Divider().padding(.vertical)
                
//                 // MARK: Footer
//                 footerSection
//             }
//             .padding()
//         }
//         .background(Color(.systemGray6))
//     }
    
//     // MARK: - Sections
    
//     private var headerSection: some View {
//         LinearGradient(
//             gradient: Gradient(colors: [Color.blue, Color.darkBlue]),
//             startPoint: .topLeading,
//             endPoint: .bottomTrailing
//         )
//         .frame(height: 140)
//         .overlay(
//             VStack {
//                 Text("John Doe's Profile")
//                     .font(.custom("Nunito-Bold", size: 32))
//                     .foregroundColor(.white)
//                 Text("\"Your Trusted Ride, Every Time!\"")
//                     .font(.custom("Nunito-Italic", size: 18))
//                     .foregroundColor(Color.lightBlue)
//             }
//         )
//         .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
//         .shadow(radius: 5)
//     }
    
//     private var profileSection: some View {
//         VStack(spacing: 16) {
//             AsyncImage(url: driverImageURL) { image in
//                 image
//                     .resizable()
//                     .aspectRatio(contentMode: .fill)
//             } placeholder: {
//                 ProgressView()
//             }
//             .frame(width: 160, height: 160)
//             .clipShape(Circle())
//             .overlay(Circle().stroke(Color.blue, lineWidth: 4))
//             .shadow(radius: 8)
            
//             VStack(spacing: 8) {
//                 Text("About John")
//                     .font(.custom("Nunito-Bold", size: 24))
//                     .foregroundColor(Color.darkBlue)
//                 Text("With over 10 years of driving experience, John is dedicated to providing safe, reliable, and friendly rides for all his passengers.")
//                     .font(.custom("Nunito-Regular", size: 16))
//                     .foregroundColor(.gray)
//                     .multilineTextAlignment(.center)
//                     .padding(.horizontal)
//             }
//         }
//     }
    
//     private var feedbackButtons: some View {
//         HStack(spacing: 30) {
//             feedbackButton(systemName: "hand.thumbsup.fill", type: "thumbsUp")
//             feedbackButton(systemName: "hand.thumbsdown.fill", type: "thumbsDown")
//             feedbackButton(systemName: "heart.fill", type: "love")
//         }
//     }
    
//     private func feedbackButton(systemName: String, type: String) -> some View {
//         Button(action: {
//             activeButton = type
//             if type == "thumbsDown" {
//                 feedbackMessage = "Thank you for your feedback!"
//             } else {
//                 feedbackMessage = "Thank you for your feedback! John has been added to your list."
//             }
//             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                 feedbackMessage = ""
//                 activeButton = nil
//             }
//         }) {
//             Image(systemName: systemName)
//                 .font(.system(size: 24))
//                 .foregroundColor(activeButton == type ? .white : Color.blue)
//                 .padding()
//                 .background(activeButton == type ? Color.blue : Color.blue.opacity(0.2))
//                 .clipShape(Circle())
//                 .scaleEffect(activeButton == type ? 1.1 : 1.0)
//                 .animation(.easeInOut, value: activeButton)
//         }
//     }
    
//     private var contactButtons: some View {
//         HStack(spacing: 20) {
//             contactButton(title: "Call John", systemName: "phone.fill") {
//                 callNumber(phoneNumber: "+1234567890")
//             }
//             contactButton(title: "Text John", systemName: "message.fill") {
//                 sendSMS(phoneNumber: "+1234567890")
//             }
//         }
//     }
    
//     private func contactButton(title: String, systemName: String, action: @escaping () -> Void) -> some View {
//         Button(action: action) {
//             HStack {
//                 Image(systemName: systemName)
//                     .foregroundColor(.white)
//                 Text(title)
//                     .font(.custom("Nunito-SemiBold", size: 16))
//                     .foregroundColor(.white)
//             }
//             .padding()
//             .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.darkBlue]), startPoint: .leading, endPoint: .trailing))
//             .cornerRadius(12)
//         }
//     }
    
//     private var paymentOptionsSection: some View {
//         VStack(alignment: .leading, spacing: 12) {
//             Text("Payment Options")
//                 .font(.custom("Nunito-Bold", size: 24))
//                 .foregroundColor(Color.darkBlue)
            
//             Text("Tap to copy a payment handle:")
//                 .font(.custom("Nunito-Regular", size: 16))
//                 .foregroundColor(.gray)
            
//             LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
//                 ForEach(payments) { payment in
//                     Button(action: {
//                         UIPasteboard.general.string = payment.handle
//                         copyMessage = "Copied \(payment.handle)!"
//                         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                             copyMessage = ""
//                         }
//                     }) {
//                         VStack(spacing: 12) {
//                             Image(payment.logoName)
//                                 .resizable()
//                                 .scaledToFit()
//                                 .frame(width: 48, height: 48)
//                             Text(payment.name)
//                                 .font(.custom("Nunito-SemiBold", size: 18))
//                                 .foregroundColor(Color.darkBlue)
//                             Text(payment.handle)
//                                 .font(.custom("Nunito-Regular", size: 14))
//                                 .foregroundColor(.gray)
//                         }
//                         .frame(width: 160, height: 140) // uniform size
//                         .background(
//                             LinearGradient(gradient: Gradient(colors: [Color.lightBlue, Color.lightBlue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
//                         )
//                         .cornerRadius(12)
//                         .shadow(radius: 3)
//                     }
//                 }
//             }
            
//             if !copyMessage.isEmpty {
//                 Text(copyMessage)
//                     .font(.custom("Nunito-Regular", size: 16))
//                     .foregroundColor(.green)
//                     .transition(.opacity)
//                     .padding(.top, 8)
//             }
//         }
//     }
    
//     private var workingHoursSection: some View {
//         VStack(alignment: .leading, spacing: 12) {
//             Text("Typical Working Hours")
//                 .font(.custom("Nunito-Bold", size: 24))
//                 .foregroundColor(Color.darkBlue)
            
//             HStack(spacing: 16) {
//                 ForEach(schedule) { item in
//                     VStack {
//                         Text(item.day)
//                             .font(.custom("Nunito-SemiBold", size: 16))
//                             .foregroundColor(Color.darkBlue)
//                             .multilineTextAlignment(.center)
//                         Text(item.hours)
//                             .font(.custom("Nunito-Regular", size: 14))
//                             .foregroundColor(.gray)
//                     }
//                     .padding()
//                     .background(
//                         LinearGradient(gradient: Gradient(colors: [Color.lightBlue, Color.lightBlue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
//                     )
//                     .cornerRadius(12)
//                     .frame(minWidth: 110)
//                 }
//             }
            
//             Button(action: {
//                 if let url = URL(string: "https://calendly.com/johndoe") {
//                     UIApplication.shared.open(url)
//                 }
//             }) {
//                 Text("Book a Ride with John")
//                     .font(.custom("Nunito-SemiBold", size: 16))
//                     .foregroundColor(.white)
//                     .padding()
//                     .frame(maxWidth: .infinity)
//                     .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.darkBlue]), startPoint: .leading, endPoint: .trailing))
//                     .cornerRadius(12)
//             }
//             .padding(.top)
//         }
//     }
    
//     private var photosSwiperSection: some View {
//         VStack(alignment: .leading, spacing: 12) {
//             Text("My Life Outside the Ride")
//                 .font(.custom("Nunito-Bold", size: 24))
//                 .foregroundColor(Color.darkBlue)
            
//             TabView {
//                 ForEach(photos) { photo in
//                     ZStack(alignment: .bottom) {
//                         AsyncImage(url: URL(string: photo.uri)) { image in
//                             image
//                                 .resizable()
//                                 .scaledToFill()
//                                 .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
//                         } placeholder: {
//                             Color.gray.opacity(0.3)
//                                 .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
//                         }
//                         .frame(height: 250)
//                         .shadow(radius: 4)
                        
//                         LinearGradient(
//                             gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
//                             startPoint: .top,
//                             endPoint: .bottom
//                         )
//                         .frame(height: 80)
//                         .cornerRadius(24)
                        
//                         Text(photo.title)
//                             .font(.custom("Nunito-SemiBold", size: 20))
//                             .foregroundColor(.white)
//                             .padding()
//                             .padding(.bottom, 10)
//                     }
//                     .padding(.horizontal)
//                 }
//             }
//             .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
//             .frame(height: 270)
//         }
//     }
    
//     private var testimonialsSection: some View {
//         VStack(alignment: .leading, spacing: 12) {
//             Text("What Clients Say")
//                 .font(.custom("Nunito-Bold", size: 24))
//                 .foregroundColor(Color.darkBlue)
            
//             ForEach(testimonials) { t in
//                 VStack(alignment: .leading, spacing: 6) {
//                     Text("\"\(t.quote)\"")
//                         .font(.custom("Nunito-Italic", size: 16))
//                         .foregroundColor(.gray)
//                     Text("- \(t.author)")
//                         .font(.custom("Nunito-SemiBold", size: 14))
//                         .foregroundColor(Color.darkBlue)
//                 }
//                 .padding()
//                 .background(Color.lightBlue.opacity(0.7))
//                 .cornerRadius(12)
//                 .shadow(radius: 3)
//             }
//         }
//     }
    
//     private var footerSection: some View {
//         LinearGradient(
//             gradient: Gradient(colors: [Color.blue, Color.darkBlue]),
//             startPoint: .topLeading,
//             endPoint: .bottomTrailing
//         )
//         .frame(height: 60)
//         .overlay(
//             Text("© 2025 Birdy LLC. All rights reserved.")
//                 .font(.custom("Nunito-Regular", size: 14))
//                 .foregroundColor(.white)
//         )
//         .cornerRadius(12)
//         .padding(.top)
//     }
    
//     // MARK: - Phone & SMS actions
    
//     private func callNumber(phoneNumber: String) {
//         if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
//             UIApplication.shared.open(url)
//         }
//     }
    
//     private func sendSMS(phoneNumber: String) {
//         if let url = URL(string: "sms:\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
//             UIApplication.shared.open(url)
//         }
//     }
// }

// // MARK: - Models

// struct PaymentOption: Identifiable {
//     let id = UUID()
//     let name: String
//     let handle: String
//     let logoName: String // Asset name
// }

// struct WorkSchedule: Identifiable {
//     let id = UUID()
//     let day: String
//     let hours: String
// }

// struct Testimonial: Identifiable {
//     let id = UUID()
//     let quote: String
//     let author: String
// }

// struct Photo: Identifiable {
//     let id = UUID()
//     let uri: String
//     let title: String
// }

// // MARK: - Color extension

// extension Color {
//     static let darkBlue = Color(red: 30/255, green: 58/255, blue: 138/255)
//     static let lightBlue = Color(red: 224/255, green: 242/255, blue: 254/255)
// }

// struct DriverDetail_Previews: PreviewProvider {
//     static var previews: some View {
//         DriverDetail()
//     }
// }
