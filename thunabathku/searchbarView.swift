import Foundation
import SwiftUI
import Combine
protocol Searchable {}

struct TrailResult: Codable, Searchable, Identifiable {
    var id: String { trail_id }
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
    let days: String
    let distance: String
    let instructions: String
    let permit_required: String
    let permit_types_accepted: String
    let difficulty_name: String
    let images: [Image]
    
    struct Image: Codable {
         let image_name: String
     }
}

struct UserResult: Codable, Searchable, Identifiable {
    var id: String { user_id }
    let user_id: String
    let name: String
    let profilepic: String
    let city: String
    let country: String
}

enum SearchResult: Identifiable {
    var id: String {
        switch self {
        case .trail(let trail):
            return trail.id
        case .user(let user):
            return user.id
        }
    }

    case trail(TrailResult)
    case user(UserResult)
}

struct MixedSearchResults: Decodable {
    let status: Int
    let message: String
    var result: [SearchResult] = []

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(Int.self, forKey: .status)
        message = try container.decode(String.self, forKey: .message)
        
        var resultsArrayForType = try container.nestedUnkeyedContainer(forKey: .result)
        while !resultsArrayForType.isAtEnd {
            if let trail = try? resultsArrayForType.decode(TrailResult.self) {
                result.append(.trail(trail))
            } else if let user = try? resultsArrayForType.decode(UserResult.self) {
                result.append(.user(user))
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case status, message, result
    }
}
class SearchBarViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [SearchResult] = []

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.performSearch(with: text)
            }
            .store(in: &cancellables)
    }

    private func performSearch(with text: String) {
        guard !text.isEmpty, let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/commonSearch?search_text=\(text)&user_id=1056&start=0") else {
            searchResults = []
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MixedSearchResults.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error during fetch: \(error)")
                }
            }, receiveValue: { [weak self] fetchedResults in
                self?.searchResults = fetchedResults.result
            })
            .store(in: &cancellables)
    }
}



struct SearchTrailView: View {
    var trail: TrailResult  // Using TrailResult structure as defined for search results

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
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
     
        
    }
}



struct UserTrailView: View {
    var user: UserResult  // Using UserResult structure as defined for search results

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.profilepic)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)  // Adjust the frame as needed
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                    .foregroundColor(.black)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                
                HStack{
                                    Text(user.city)
                                        .font(.subheadline)
                                        .padding(.bottom, 4)
                                        .foregroundColor(.gray)
                                    
                                    Text(",")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text(user.country)
                                        .font(.subheadline)
                                        .padding(.bottom, 4)
                                        .foregroundColor(.gray)
                                }
            }
            
            Spacer()
        }
        .padding(8)
        //.background(Color.white) // Set your desired background color
       // .cornerRadius(10)
       // .shadow(radius: 5)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
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

            List(viewModel.searchResults, id: \.id) { result in
                switch result {
                case .trail(let trail):
                    SearchTrailView(trail: trail)
                        .frame(width: 350, height: 100)
                case .user(let user):
                    UserTrailView(user: user)
                        .frame(width: 350, height: 70)
                    
                }
            }
            .listStyle(GroupedListStyle())
            
            
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}


