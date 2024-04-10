import SwiftUI

struct sideMenu: View {
    var body: some View {
        VStack{
            Text("settings")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(32)
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    sideMenu()
}
