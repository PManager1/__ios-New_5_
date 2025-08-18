
import SwiftUI


struct VehicleInfo: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            Text("VehicleInfo Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .navigationTitle("VehicleInfo Screen")
    }
}

struct VehicleInfo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VehicleInfo()
        }
    }
}
