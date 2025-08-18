import SwiftUI

struct UserStats: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Profile Section
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text("JAY")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Button(action: {}) {
                        Text("View public profile")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // Rides Section
                Text("Rides")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                VStack(spacing: 10) {
                    // Top row with two tiles
                    HStack(spacing: 10) {
                        StatView(title: "Star rating", value: "4.41★", status: "Uber Pro", statusColor: .red)
                        StatView(title: "Acceptance rate", value: "6%", status: "Uber Pro", statusColor: .red)
                    }
                    // Bottom row with two tiles
                    HStack(spacing: 10) {
                        StatView(title: "Cancellation rate", value: "3%", status: "Uber Pro", statusColor: .green)
                        StatView(title: "Driving Insights score", value: "93", status: "", statusColor: .black)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarItems(leading: Button(action: {}) {
                Image(systemName: "chevron.left")
            }, trailing: Text("You're online")
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .background(Color.blue)
                .cornerRadius(10))
            .padding()
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    let status: String
    let statusColor: Color
    
    init(title: String, value: String, status: String = "", statusColor: Color = .black) {
        self.title = title
        self.value = value
        self.status = status
        self.statusColor = statusColor
    }
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
            Text(status)
                .font(.caption2)
                .foregroundColor(statusColor)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct UserStats_Previews: PreviewProvider {
    static var previews: some View {
        UserStats()
    }
}