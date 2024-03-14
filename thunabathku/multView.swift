import SwiftUI


struct multrailCardView: View {
    var trail: MultidayTrail
    var difficulty: DifficultyLevel?
    var difficultyViewModel: DifficultyViewModel
    @State var DV=false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack(alignment: .topLeading){
                
                
                AsyncImage(url: URL(string: trail.images.first?.image_name ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 110) // Slightly smaller square image
                            .clipped()
                            .cornerRadius(8) // Adjusted corner radius
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100) // Slightly smaller square image
                            .clipped()
                            .cornerRadius(8) // Adjusted corner radius
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2) // Outline of the card
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                difficulty.map {
                    Text($0.name)
                        .padding(.leading, 5)
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .font(.footnote)
                        .background(Color.orange)
                        
                }
                
                
                
                
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trail.trail_name)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.orange)
                    Text(trail.area)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.orange)
                    Text("Duration:")
                        .foregroundColor(.black)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    Text("\(trail.days) days")
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                }
                
                HStack {
                    Image(systemName: "arrow.right.circle")
                        .foregroundColor(.orange)
                    Text("Distance:")
                        .foregroundColor(.black)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    Text(trail.distance)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    Spacer()
                }
            }
            .padding(8)
        }
        .background(Color.white) // Set your desired background color
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .onTapGesture {
            print("\(trail.trail_name)")
            DV=true
            
        }
        
        NavigationLink(
            destination: TrailDetails(Id: trail.trail_id) ,
                     isActive: $DV
                 ) {
                     EmptyView()
                 }
                 .hidden()// Slightly reduced vertical padding
    }
}





struct multrailCardsScrollView: View {
    var trails: [MultidayTrail]
    @ObservedObject var trailViewModel: MulTrailViewModel
    @ObservedObject var difficultyViewModel: DifficultyViewModel



    var body: some View {
        ScrollView {
            ForEach(trails, id: \.trail_id) { trail in
                if let difficulty = difficultyViewModel.difficultyLevels.first(where: { $0.difficulty_id == trail.trailDifficultyID }) {
    
                        multrailCardView(trail: trail, difficulty: difficulty, difficultyViewModel: difficultyViewModel)  // Pass 'difficultyViewModel'
                            .frame(width: 240, height: 160)
                            //.background(Color.red)
                            .padding(.trailing, 16)
                            .padding(.top, 16)
                            
                    
                }
            }
            .padding([.leading, .trailing], 16)
        }
    }
}







struct multView: View {
    @StateObject private var trailViewModel = MulTrailViewModel()
    @StateObject private var difficultyViewModel = DifficultyViewModel()
    @State private var DV=false

    var body: some View {
        VStack {
            Text("Multi-day Trails")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                            .padding(.top, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(trailViewModel.multrails.prefix(5), id: \.trail_id) {trail in
                if let difficulty = difficultyViewModel.difficultyLevels.first(where: { $0.difficulty_id == trail.trailDifficultyID }) {
    
                        multrailCardView(trail: trail, difficulty: difficulty, difficultyViewModel: difficultyViewModel)  // Pass 'difficultyViewModel'
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 16)
                            .onTapGesture {
                                DV=true
                            }
                            
                    
                }
            }
            .padding([.leading, .trailing], 16)
        }
        //.navigationTitle("Multiday Trails")
        .task {
            await trailViewModel.fetchData()
            await difficultyViewModel.fetchDifficultyLevels()
        }
        
       
    }

}


#Preview {
    multView()
}
