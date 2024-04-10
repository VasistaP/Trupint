import SwiftUI

// Enum to manage navigation destinations
enum NavigationDestination {
    case activityDetail(String)
    case comments(String)
}

struct FeedPage: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject var viewModel = ActivityViewModel()
    @State private var navigationDestination: NavigationDestination? // Tracks the current navigation destination
    
    let baseURL = "https://app.trooperworld.com/php/trooper/uploads/"
    
    func jsonDecodedString(from string: String) -> String {
        let quotedString = "\"\(string)\""
        guard let data = quotedString.data(using: .utf8),
              let decodedString = try? JSONDecoder().decode(String.self, from: data) else {
            return string // Return the original string if decoding fails
        }
        return decodedString
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.orange
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 40)
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                            .font(.system(size: 30))
                        
                        Text("Feed")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    .padding(.top, -5)
                    
                    List(viewModel.activities, id: \.id) { activity in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                AsyncImage(url: URL(string: activity.profilepic)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
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
                                
                                Text(activity.username)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding([.top, .horizontal])
                            
                            AsyncImage(url: URL(string: "\(baseURL)\(activity.static_map_image ?? "")")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150)
                                        .cornerRadius(8)
                                case .failure:
                                    Image(systemName: "map")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150)
                                        .cornerRadius(8)
                                        .foregroundColor(.gray)
                                }
                            }

                            Text(activity.name)
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            HStack(spacing: 40) {
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
                                                            Text("\(activity.likescount) likes")
                                                                .font(.subheadline)
                                                                .foregroundColor(.black)
                                                                .padding(.leading, 5)
                                                        }
                            

                            // Other details...
                            
                            if let comment = activity.comment {
                                VStack {
                                    HStack {
                                        AsyncImage(url: URL(string: comment.profilepic)) { phase in
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
                                            Text(comment.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text(jsonDecodedString(from: comment.comment))
                                                .font(.system(size: 14))
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                    }
                                    .onTapGesture {
                                        self.navigationDestination = .comments(activity.id)
                                    }
                                    .frame(width: 300, height: 30)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding([.trailing], -10)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding([.top, .horizontal])
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            self.navigationDestination = .activityDetail(activity.id)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(
                Group {
                    switch navigationDestination {
                    case .activityDetail(let activityId):
                        NavigationLink(destination: ActivityDetailView(activityId: activityId), isActive: Binding<Bool>(
                            get: { if case .activityDetail = navigationDestination { return true } else { return false }},
                            set: { if !$0 { navigationDestination = nil }}
                        )) {
                            EmptyView()
                        }
                    case .comments(let postId):
                        NavigationLink(destination: CommentsView(postId: postId), isActive: Binding<Bool>(
                            get: { if case .comments = navigationDestination { return true } else { return false }},
                            set: { if !$0 { navigationDestination = nil }}
                        )) {
                            EmptyView()
                        }
                    case .none:
                        EmptyView()
                    }
                }
                .hidden()
            )
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.update(loggedInUser: loginViewModel.loggedInUser)
                viewModel.fetchActivities()
            }
        }
    }
}
struct FeedPage_Previews: PreviewProvider {
    static var previews: some View {
        let mockUser = LoggedInUser(user_id: "1056", email: "test@example.com", name: "Test User", city: "Test City", country: "Test Country", profilepic: "")
 // Fill in the rest of the required fields
        let loginViewModel = LoginViewModel(loggedInUser: mockUser)
        FeedPage().environmentObject(loginViewModel)

    }
}
