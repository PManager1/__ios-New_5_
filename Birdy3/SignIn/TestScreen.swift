import SwiftUI

struct TestScreensView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var authStore: AuthStore
    @State private var isDrawerOpen = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    Text("Test screens")
                        .font(.custom("Nunito-Bold", size: 24))
                        .padding(.bottom, 10)
                    
                    // Old Stuff Section
                    Text("Old stuff")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(Color(red: 30/255, green: 64/255, blue: 175/255))
                        .padding(.top, 10)

                        
                    
                    // Other Screens Section
                    DividerView()
                    Text("Other Screens")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(Color(red: 30/255, green: 64/255, blue: 175/255))
                        .padding(.top, 10)
                
                }
                .padding()
            }
            
            // Drawer
            GeometryReader { geometry in
                 
            }
            .background(
                Color.black.opacity(isDrawerOpen ? 0.5 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if isDrawerOpen {
                            isDrawerOpen = false
                        }
                    }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { isDrawerOpen.toggle() }) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.black)
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        isDrawerOpen = true
                    } else if value.translation.width < -100 {
                        isDrawerOpen = false
                    }
                }
        )
        .navigationBarBackButtonHidden(false) // Single back button to Main Menu
    }
}

struct SettingsButton: View {
    let title: String
    let color: Color
    let destination: () -> any View
    
    var body: some View {
        NavigationLink {
            AnyView(destination())
        } label: {
            Text(title)
                .font(.custom("Nunito-Bold", size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color)
                .cornerRadius(10)
        }
    }
}

struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.gray)
            .padding(.vertical, 10)
    }
}

struct PlaceholderView: View {
    let name: String
    var body: some View {
        Text("\(name) Screen")
            .font(.custom("Nunito-Bold", size: 24))
            .padding()
    }
}

struct TestScreensView_Previews: PreviewProvider {
    @State static var path = NavigationPath()
    
    static var previews: some View {
        TestScreensView(path: $path)
            .environmentObject(AuthStore())
    }
}

