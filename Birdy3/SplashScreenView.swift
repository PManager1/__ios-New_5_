
import SwiftUI

 

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.purple // Custom non-white background
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "bird.fill") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                
                Text("Birdy Yo")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
}
