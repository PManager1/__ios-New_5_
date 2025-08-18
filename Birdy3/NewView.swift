
import SwiftUI

struct NewView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            Text("First Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .navigationTitle("First Screen")
    }
}

struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewView()
        }
    }
}
