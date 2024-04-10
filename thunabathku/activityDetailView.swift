import SwiftUI
import Combine

struct ActivityDetailView: View {
    let activityId: String
    @StateObject private var viewModel: ActivityDetailViewModel
    @Environment(\.presentationMode) var presentationMode

    init(activityId: String) {
        self.activityId = activityId
        _viewModel = StateObject(wrappedValue: ActivityDetailViewModel(activityId: activityId))
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.orange
                .edgesIgnoringSafeArea(.all)
                .frame(height: 100)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .padding(.leading, 10)
                    
                    Text("Activity Details")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                .padding(.top, 40)
                .frame(height: 100)
                
                ScrollView {
                    if let activityDetail = viewModel.activityDetail {
                        
                        TabView {
                                                        ForEach(activityDetail.activity_images, id: \.image) { activityImage in
                                                            AsyncImage(url: URL(string: activityImage.image)) { phase in
                                                                switch phase {
                                                                case .empty:
                                                                    ProgressView()
                                                                case .success(let image):
                                                                    image
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fill)
                                                                        .frame(width: UIScreen.main.bounds.width, height: 350)
                                                                        .clipped()
                                                                case .failure:
                                                                    Image(systemName: "photo")
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .frame(width: UIScreen.main.bounds.width, height: 350)
                                                                @unknown default:
                                                                    EmptyView()
                                                                }
                                                            }
                                                        }
                                                    }
                                                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                                    .frame(height: 200)
                        
                        
                        
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text(activityDetail.name)
                                    .font(.system(size: 20)) // Adjust the font as needed
                                Text(activityDetail.createdat)
                                    .padding(.top, 10)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                 
                            }
                            .padding(.leading, 10)
                            
                            Spacer()
                            
                            
                            VStack(alignment: .trailing){
                                Text("Points Earned")
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                    Text(activityDetail.points)
                                }
                                
                            }
                            .padding(.trailing, 10)
                            
                            
                                }
                        .padding(.leading, 5)
                        
                        
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.orange.opacity(0.1)) // Adjust the opacity as needed
                                .frame(height: 40) // Adjust the height as needed

                            HStack {
                                AsyncImage(url: URL(string: activityDetail.profilepic)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView() // Placeholder for loading state
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "person.crop.circle.badge.exclamationmark") // Placeholder for failure state
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    @unknown default:
                                        EmptyView() // Fallback for unknown state
                                    }
                                }
                                //.padding(.leading, 10)
                                
                                Text(activityDetail.username) // Dynamic username
                                    .font(.headline)
                    
                                
                                Spacer() // This spacer pushes everything to the left and the next element to the right

                                // Displaying activityDetail.difficulty_name on the right
                                Text(activityDetail.difficulty_name)
                                    .font(.system(size: 14, weight: .black))
                                    .font(.headline)// Reduces size to 14 and uses a lighter weight
                                    //.padding(.trailing, 10) // Ensures there's some space to the right edge
                            }
                            .padding(.horizontal)
                        }


                        
                        let columns = [GridItem(.flexible()), GridItem(.flexible())]
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            DetailViewRow(label: "Time", value: activityDetail.elapsed_time, systemImageName: "clock.fill")
                            DetailViewRow(label: "Distance", value: activityDetail.distance, systemImageName: "point.fill.topleft.down.curvedto.point.fill.bottomright.up")
                            DetailViewRow(label: "Avg Pace", value: activityDetail.avg_pace, systemImageName: "hare.fill")
                            DetailViewRow(label: "Avg Speed", value: activityDetail.avg_speed, systemImageName: "speedometer")
                            DetailViewRow(label: "Start Elevation", value: activityDetail.start_elevation ?? "N/A", systemImageName: "arrow.up.circle.fill")
                            DetailViewRow(label: "End Elevation", value: activityDetail.end_elevation ?? "N/A", systemImageName: "arrow.down.circle.fill")
                            DetailViewRow(label: "Min Elevation", value: activityDetail.min_elevation ?? "N/A", systemImageName: "arrow.down.to.line.alt")
                            DetailViewRow(label: "Max Elevation", value: activityDetail.max_elevation ?? "N/A", systemImageName: "arrow.up.to.line.alt")
                            DetailViewRow(label: "Elevation Gain", value: activityDetail.elevation_gain ?? "N/A", systemImageName: "mountain.2.fill")
                            DetailViewRow(label: "Calories", value: "\(activityDetail.calories.map { String($0) } ?? "N/A")", systemImageName: "flame.fill")
                        }
                        .padding(.horizontal)

                    } else {
                        ProgressView("Fetching activity details...")
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct DetailViewRow: View {
    var label: String
    var value: String
    var systemImageName: String

    var body: some View {
        HStack(spacing: 16) { // Add some spacing between image and text
            Image(systemName: systemImageName)
                .foregroundColor(.orange)
                .frame(width: 20, height: 20) // Specify a fixed frame for the image
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(label + ":")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure text aligns to the left
                Text(value)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity) // Use the maximum width available to ensure consistent alignment
    }
}


// Preview for SwiftUI canvas, replace with actual values if necessary
struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activityId: "2200")
    }
}
