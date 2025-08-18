// import SwiftUI

// struct SwiperView: View {
//     @State private var showAlert = false

//     var body: some View {
//         ZStack {
//             LinearGradient(colors: [.white, .blue.opacity(0.1)], startPoint: .top, endPoint: .bottom)
//                 .ignoresSafeArea()

//             VStack(spacing: 50) {
//                 Text("Swipe to Confirm")
//                     .font(.largeTitle)
//                     .fontWeight(.bold)
//                     .foregroundColor(.black)

//                 Text("Slide the button to the right to confirm your action")
//                     .font(.subheadline)
//                     .foregroundColor(.gray)
//                     .multilineTextAlignment(.center)
//                     .padding(.horizontal)

//                 SwipeButton(showAlert: $showAlert)
//                     .frame(height: 80)
//                     .padding(.horizontal, 30)

//                 Spacer()
//             }
//             .padding(.top, 100)
//         }
//         .alert(isPresented: $showAlert) {
//             Alert(
//                 title: Text("Confirmed"),
//                 message: Text("You have successfully swiped!"),
//                 dismissButton: .default(Text("OK"))
//             )
//         }
//         .navigationTitle("Swiper Screen 2")
//     }
// }

// struct SwipeButton: View {
//     @Binding var showAlert: Bool
//     @State private var offset: CGFloat = 0
//     @State private var isSwiped = false
//     private let handleSize: CGFloat = 70

//     var body: some View {
//         GeometryReader { geometry in
//             ZStack(alignment: .leading) {
//                 // Track
//                 RoundedRectangle(cornerRadius: 40)
//                     .fill(LinearGradient(colors: [Color.gray.opacity(0.15), Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing))
//                     .frame(height: handleSize)
//                     .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 3)

//                 // Label
//                 Text("Slide to Confirm")
//                     .foregroundColor(.gray)
//                     .fontWeight(.medium)
//                     .padding(.leading, 85)

//                 // Handle
//                 ZStack {
//                     Circle()
//                         .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
//                         .frame(width: handleSize, height: handleSize)
//                         .shadow(color: .black.opacity(0.2), radius: 8, x: 2, y: 4)

//                     Image(systemName: "chevron.right")
//                         .foregroundColor(.white)
//                         .font(.system(size: 28, weight: .bold))
//                 }
//                 .offset(x: offset)
//                 .gesture(
//                     DragGesture()
//                         .onChanged { value in
//                             let maxOffset = geometry.size.width - handleSize
//                             offset = min(max(0, value.translation.width), maxOffset)

//                             if offset >= maxOffset * 0.85 && !isSwiped {
//                                 isSwiped = true
//                                 showAlert = true
//                             }
//                         }
//                         .onEnded { _ in
//                             withAnimation(.easeOut) {
//                                 offset = 0
//                                 isSwiped = false
//                             }
//                         }
//                 )
//             }
//             .frame(height: handleSize)
//         }
//     }
// }

// struct SwiperView_Previews: PreviewProvider {
//     static var previews: some View {
//         NavigationView {
//             SwiperView()
//         }
//     }
// }
