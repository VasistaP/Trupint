import SwiftUI
import Combine






struct Trail: Codable {
    struct TrailResult: Codable {
        let trail_id: String
        let trail_name: String
        let description: String
        let trail_northeast: String
        let trail_southwest: String
        let max_altitude: String
        let min_altitude: String
        let area: String
        let state: String
        let country: String
        let base_camp_name: String
        let base_camp_latitude: String
        let base_camp_longitude: String
        let base_camp_altitude: String
        let terminal_point_one_name: String
        let terminal_point_one_lat: String
        let terminal_point_one_long: String
        let terminal_point_one_alt: String
        let is_base_camp_terminal_point_one: String
        let terminal_point_two_name: String
        let terminal_point_two_lat: String
        let terminal_point_two_long: String
        let terminal_point_two_alt: String
        let is_base_camp_terminal_point_two: String
        let nearest_town: String
        let atm_available: String
        let cellphone_reception: String
        let mobile_internet: String
        let trail_month: String
        let trail_popularity: String
        let difficulty_id: String
        let days: String
        let distance: String
        let instructions: String
        let permit_required: String
        let permit_types_accepted: String
        let difficulty_name: String
        let images: [Image]
    }

    struct Image: Codable {
        let image_name: String
    }

    let status: Int
    let message: String
    let result: [TrailResult]
}

struct User: Codable{
    struct UserResult: Codable {
        let user_id: String
        let email: String
        let password: String
        let name: String
        let city: String
        let state: String
        let dob: String
        let height: String
        let weight: String
        let gender: String
        let profilepic: String
        let socialtype_fb: String
        let fb_id: String
        let socialtype_google: String
        let google_id: String
        let country: String
        let country_code: String
        let mobile: String
        let emergency_country_code: String
        let emergency_country_code_name: String
        let emergency_mobile: String
        let relation: String
        let relation_other: String
        let role: String
        let is_noti_enable: String
        let isActive: String
        let isDeleted: String
        let last_login_time: String
        let last_noti_seen_time: String
        let created_time: String
        let sent_mail: String
        let description: String
        let isFollowing: Int
        let type: Int
    }
    
    let status: Int
    let message: String
    let result: [UserResult]
}



class SearchBarViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var trailsearchResults: [Trail.TrailResult] = []
    @Published var usersearchResults: [User.UserResult] = []

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
    }

    private func performSearch() {
        // Construct the URL with the current search text
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/commonSearch?search_text=\(searchText.lowercased())&user_id=1&start=0") else {
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Trail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] trail in
                self?.trailsearchResults = trail.result
            }
            .store(in: &cancellables)
        
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] user in
                self?.usersearchResults = user.result
            }
            .store(in: &cancellables)
    }
}

struct SearchBarView: View {
    @StateObject private var viewModel = SearchBarViewModel()

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)

                TextField("Search", text: $viewModel.searchText)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)

            // Display search results
            List(viewModel.trailsearchResults, id: \.trail_id) { trail in
                TrailRow(trail: trail)
            }
            .frame(width: 400, height: 500)
            //.listStyle(InsetGroupedListStyle())
            
            List(viewModel.usersearchResults, id: \.user_id) { user in
                UserRow(user: user)
            }
            .listStyle(InsetGroupedListStyle())

            Spacer() // Pushes the SearchBarView to the top
        }
        .padding(.horizontal)
    }
}

struct TrailRow: View {
    var trail: Trail.TrailResult

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
        .frame(width: 350, height: 110)
        .padding(.vertical, 8)
    }
}

struct UserRow: View {
    var user: User.UserResult

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.profilepic)) { phase in
                        switch phase {
                        case .empty:
                            // Placeholder image or loading indicator
                            ProgressView()
                        case .success(let image):
                            // Actual image loaded
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        case .failure:
                            // Error placeholder or message
                            Image(systemName: "exclamationmark.triangle")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                        }
                    }
            
            VStack(alignment: .leading, spacing: 4){
                Text(user.name)
                    .font(.headline)
                    .padding(.bottom, 4)
                HStack{
                    Text(user.city)
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Text(",")
                    
                    Text(user.country)
                        .font(.headline)
                        .padding(.bottom, 4)
                }
            }
            
        }
    }
}



#Preview {
    SearchBarView()
}
