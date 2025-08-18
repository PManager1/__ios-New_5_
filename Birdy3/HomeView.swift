
import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            Text("Home Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .navigationTitle("Add more screens here")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
