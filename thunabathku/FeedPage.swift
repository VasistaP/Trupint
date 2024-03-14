import SwiftUI

struct FeedPage: View {
    
    @ObservedObject var viewModel = ActivityViewModel()
    let base_url = "https://app.trooperworld.com/php/trooper/uploads/"
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.orange
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 40)
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "line.horizontal.3") // Menu logo
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                            .font(.system(size: 40))
                        
                        Text("Feed")
                            .font(.system(size: 30))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                            
                            
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    List(viewModel.activities, id: \.id) { activity in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                // Display profile picture at the top left
                                AsyncImage(url: URL(string: activity.profilepic)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    case .failure:
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    }
                                }
                                .padding(.trailing, 8)
                                
                                // Display username to the right of the profile picture
                                Text(activity.username)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                            }
                            .padding([.top, .horizontal])
                            
                            // Display placeholder image for the map
                            AsyncImage(url: URL(string: base_url + activity.static_map_image)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150)
                                        .cornerRadius(8)
                                case .failure(_):
                                    // Handle failure, show a placeholder map image
                                    Image(systemName: "map.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 100)
                                        .cornerRadius(8)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            // Display name below the map placeholder
                            Text(activity.name)
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            // Display distance and elevation gain beside each other
                            HStack(spacing: 40) {
                                // Display distance and elevation gain beside each other
                                VStack(alignment: .leading){
                                    Text("Distance:")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(activity.distance)")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .padding(.top, 4)
                                
                                VStack(alignment: .leading){
                                    Text("Elevation Gain:")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(activity.elevation_gain)")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .padding(.top, 4)
                                
                                VStack(alignment: .leading){
                                    Text("Time:")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(activity.elapsed_time)")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .padding(.top, 4)
                                
                            }
                            
                            Divider()
                            
                            HStack(spacing:115) {
                                Image(systemName: "heart")
                                Image(systemName: "bubble.right")
                                Image(systemName: "arrowshape.turn.up.right")
                            }
                            
                            
                            Text("Likes: \(activity.likescount)")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            // Display likers' profile pictures
                            HStack {
                                ForEach(activity.likes.prefix(3), id: \.id) { like in
                                    AsyncImage(url: URL(string: like.profilepic)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 20, height: 20)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                                .padding(.trailing, -10)
                                        case .failure:
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 20, height: 20)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                                .padding(.trailing, -10)
                                        }
                                    }
                                }
                            }
                            if let firstComment = activity.commentscount > 0 ? activity.comment.comment : nil {
                                VStack {
                                    HStack() {
                                        AsyncImage(url: URL(string: activity.comment.profilepic)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 30, height: 30)
                                                    .clipShape(Circle())
                                            case .failure:
                                                Image(systemName: "person.circle")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 30, height: 30)
                                                    .clipShape(Circle())
                                            }
                                        }
                                        .padding(.trailing, 8)
                                        
                                        VStack(alignment: .leading) {
                                            Text(activity.comment.name)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Text(firstComment)
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .frame(width:300, height:30)
                                    .padding()
                                    .background(Color.gray.opacity(0.3)) // Set the background color here
                                    .cornerRadius(10) // Adjust the corner radius as needed
                                    .padding([.trailing], -10) // Adjust the leading padding
                                }
                            }
                            
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding([.top, .horizontal])
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(GroupedListStyle())
                    .padding(.bottom, 100)
                    
                    
                }
            }
            .onAppear {
                viewModel.fetchActivities() // Ensure data is fetched when the view appears
            }
        }
    }
}

struct FeedPage_Previews: PreviewProvider {
    static var previews: some View {
        FeedPage()
    }
}
