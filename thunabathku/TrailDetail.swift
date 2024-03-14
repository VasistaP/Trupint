import SwiftUI

struct TrailDetails: View {
    //@State private var trailInfo: [String: Any]?
    var Id: String

    var body: some View {
       Text("Hello \(Id)")
    }

  
}

struct TrailDetails_Previews: PreviewProvider {
    static var previews: some View {
        TrailDetails(Id:"1")
    }
}
