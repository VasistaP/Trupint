import SwiftUI

struct weekndTrailCardView: View {
    var trail: WeekendTrail
    var difficulty: DifficultyLevel?
    var difficultyViewModel: DifficultyViewModel
    @State var DV=false

    var body: some View {
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
                

            
        

        }
        .shadow(radius: 5)
        .frame(width: 200, height: 120)
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
                 .hidden()
    }
}

struct weekndCardsScrollView: View {
    var trails: [WeekendTrail]
    @ObservedObject var difficultyViewModel: DifficultyViewModel
    @State private var DV=false

    var body: some View {
        Text("Weekend Trails")
            .font(.title)
            .fontWeight(.bold)
            .padding(.leading, 16)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(trails, id: \.trail_id) { trail in
                    if let difficulty = difficultyViewModel.difficultyLevels.first(where: { $0.difficulty_id == trail.trailDifficultyID }) {
                        weekndTrailCardView(trail: trail, difficulty: difficulty, difficultyViewModel: difficultyViewModel)
                            .frame(width: 240, height: 160)
                            //.background(Color.red)
                            .padding(.trailing, -125)
                            .padding(.top, 16)
                            .onTapGesture {
                                print("\(trail.trail_name)")
                                DV=true
                            }
                        
                        
                    }
                }
            }
            .padding([.leading], 16)
        }
    }
}

struct wkndView: View {
    @StateObject private var weekendTrailsViewModel = WeekendTrailsViewModel()
    @StateObject private var difficultyViewModel = DifficultyViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Weekend Trails Section
                weekndCardsScrollView(trails: weekendTrailsViewModel.weekendTrails, difficultyViewModel: difficultyViewModel)
                    //.navigationTitle("Weekend Trails")
                    .task {
                        await weekendTrailsViewModel.fetchData()
                        await difficultyViewModel.fetchDifficultyLevels()
                        print("Number of weekend trails:", weekendTrailsViewModel.weekendTrails.count)
                        print("Number of difficulty levels:", difficultyViewModel.difficultyLevels.count)
                    }
                   
                    .padding(.bottom, 0)
            }
        }
    }
}

#Preview {
    wkndView()
}
