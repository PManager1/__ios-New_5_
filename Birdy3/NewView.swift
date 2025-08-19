


import SwiftUI

struct NewView: View {
    
    @Binding var path: NavigationPath

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
        NavigationStack {
            NewView(path: .constant(NavigationPath()))
        }
    }
}



