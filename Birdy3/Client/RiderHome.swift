import SwiftUI

struct RiderHome: View {
    @State private var destination: String = ""
    @State private var containerScale: CGFloat = 1.0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Spacer()
                        Image(systemName: "car")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                        Text("Rides")
                            .font(.custom("Nunito-Bold", size: 24))
                            .foregroundColor(.black)
                        Spacer()
                    }

                    // Main Container
                    VStack(spacing: 15) {
                        // Search Input Container
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(width: 24, height: 24)
                                .padding(.leading, 10)

                            TextField("Where to?", text: $destination)
                                .font(.custom("Nunito-Regular", size: 16))
                                .foregroundColor(.black)
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.15)) {
                                        containerScale = 0.98
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            containerScale = 1.0
                                            print("Navigating to RidePlan with destination: \(destination)")
                                        }
                                    }
                                }

                            Spacer()
                        }
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(25)
                        .padding(.horizontal, 15)

                        // Recent Location 1
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.15)) {
                                containerScale = 0.98
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    containerScale = 1.0
                                    print("Selected: 28 Froude Cir, Cabin John, MD")
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "location")
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 10)

                                VStack(alignment: .leading) {
                                    Text("32 Froude Cir")
                                        .font(.custom("Nunito-SemiBold", size: 16))
                                        .foregroundColor(.black)
                                    Text("Cabin John, MD")
                                        .font(.custom("Nunito-Regular", size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 10)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                            .background(Color.gray.opacity(0.02))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 15)

                        // Recent Location 2
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.15)) {
                                containerScale = 0.98
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    containerScale = 1.0
                                    print("Selected: 95 Garrisonville Rd, Stafford, VA")
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "location")
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 10)

                                VStack(alignment: .leading) {
                                    Text("Rosner Toyota of Stafford")
                                        .font(.custom("Nunito-SemiBold", size: 16))
                                        .foregroundColor(.black)
                                    Text("95 Garrisonville Rd, Stafford, VA")
                                        .font(.custom("Nunito-Regular", size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 10)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                            .background(Color.gray.opacity(0.02))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 15)
                    }
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .scaleEffect(containerScale)
                }
                .padding(.top, 0) // No top padding to move content to the top
                .padding(.bottom, 20)
            }
            .background(Color(.systemGray6))
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

// Custom modifier for rounded corners on specific corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RiderHome_Previews: PreviewProvider {
    static var previews: some View {
        RiderHome()
    }
}
