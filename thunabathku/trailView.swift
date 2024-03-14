import SwiftUI




/*struct TrailDetailView: View {
    @ObservedObject var trailViewModel: TrailViewModel
    var trail: PopularTrail

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(trail.trail_name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                // Additional details can be added here

            }
            .padding()
        }
    }
}*/


struct TrailCardView: View {
    var trail: PopularTrail
    var difficulty: DifficultyLevel?
    var difficultyViewModel: DifficultyViewModel
    @State var DV=false
    
    var body: some View {
        NavigationView{
        ZStack(alignment: .topLeading) {
            AsyncImage(url: URL(string: trail.images.first?.image_name ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 239, height: 155)
                        .clipped()
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(minHeight: 40, maxHeight: 120)
                        .clipped()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(trail.trail_name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow for readability
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.orange)
                    Text(trail.area)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.orange)
                    Text("Duration:")
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                    Text("\(trail.days) days")
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                }
                
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.orange)
                    Text("Distance:")
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                    Text(trail.distance)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                    Spacer()
                }
                
                difficulty.map {
                    Text($0.name)
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .font(.footnote)
                        .background(Color.orange)
                        .padding(.top, 2)
                        .padding(.leading, 10)
                }
                
            }
            .padding(10)
            .cornerRadius(10)
            
            
            
            
        }.onTapGesture {
            print("\(trail.trail_name)")
            DV=true
         
        }
        .shadow(radius: 5)
        .frame(width: 200, height: 120)

    }
        NavigationLink(
            destination: TrailDetails(Id: trail.trail_id) ,
                     isActive: $DV
                 ) {
                     EmptyView()
                 }
                 .hidden()
}
    
    
}


struct TrailCardsScrollView: View {
    var trails: [PopularTrail]
    @ObservedObject var trailViewModel: TrailViewModel
    @ObservedObject var difficultyViewModel: DifficultyViewModel
    @State var DV=false
    var body: some View {
        Text("Popular Trails")
            .font(.title)
            .fontWeight(.bold)
            .padding(.leading, 16)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(trails, id: \.trail_id) { trail in
                    if let difficulty = difficultyViewModel.difficultyLevels.first(where: { $0.difficulty_id == trail.trailDifficultyID }) {
        
                            TrailCardView(trail: trail, difficulty: difficulty, difficultyViewModel: difficultyViewModel)
                            .onTapGesture {
                                print("\(trail.trail_name)")
                                DV=true
                                
                             
                            }// Pass 'difficultyViewModel'
                                .frame(width: 240, height: 160)
                                //.background(Color.red)
                                .padding(.trailing, -125)
                                .padding(.top, 16)
                                
                        
                    }
                }
            }
            .padding([.leading], 16)
        }
    }
}


struct trailView: View {
   
    @StateObject private var trailViewModel = TrailViewModel()
    @StateObject private var difficultyViewModel = DifficultyViewModel()
    @State private var DV = false
    @State private var name_t=" "
    var body: some View {
        NavigationView{
        
        ScrollView {
            VStack(spacing: 0) {
                // Popular Trails Section
                TrailCardsScrollView(trails: trailViewModel.trails, trailViewModel: trailViewModel, difficultyViewModel: difficultyViewModel).onTapGesture {
//                    DV=true
//                    name_t=trailViewModel.trails.trail_name
                }
                   // .navigationTitle("Popular Trails")
                    .task {
                        await trailViewModel.fetchData()
                        await difficultyViewModel.fetchDifficultyLevels()  // Fetch difficulty levels
                        print("Number of trails:", trailViewModel.trails.count)
                        print("Number of difficulty levels:", difficultyViewModel.difficultyLevels.count)
                    }
                    .padding(.bottom, 0)
                // Multiday Trails Section
                multView()
                wkndView()
//                NavigationLink(
//                    destination: TrailDetails(name_t: name_t) ,
//                             isActive: $DV
//                         ) {
//                             EmptyView()
//                         }
//                         .hidden()
//
                
            }
        }
    }
}
}

#Preview{
    trailView()
}
