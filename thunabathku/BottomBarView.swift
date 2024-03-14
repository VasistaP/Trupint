import SwiftUI

struct BottomBarView: View {
    @State var FeedClick=false
    @State var TrialClick=false
    @State var Record=false
    @State var SearchClick=false
    @State var ProfileClick=false
    var body: some View {
        TabView {
            
            // Button 1
            FeedPage()
                .tabItem {
                    Image(systemName: "house")

                    Text("Feed")
                }
                .tag(0)
            
            // Button 2
            trailView()
                .tabItem {
                    Image(systemName: "road.lanes.curved.right")

                    Text("Trail")
                   
                }
                .tag(1)
            
            // Button 3
            RecordPage()
                .tabItem {
                    Image(systemName: "record.circle")
                    Text("Record")
                }
                .tag(2)
            
            // Button 4
            SearchBarView()
                .tabItem {
                    Image(systemName: "magnifyingglass")

                    Text("Search")
                }
                .tag(3)
            
            // Button 5
            ProfilePage()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.orange)
        .navigationBarBackButtonHidden(true)// Change the accent color as per your preference
   
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
    }
}
