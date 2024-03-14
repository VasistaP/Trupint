import SwiftUI
import Foundation
import Combine

class TrailViewModel: ObservableObject {
    @Published var trails: [PopularTrail] = []
    @Published var selectedTrail: PopularTrail?

    func fetchData() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/popularTrailsExploreAll?start=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([PopularTrail].self, from: JSONSerialization.data(withJSONObject: result))
                trails = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }

    func selectTrail(_ trail: PopularTrail) {
        selectedTrail = trail
    }
}

struct PopularTrail: Codable {
    var trail_id: String
    var trail_name: String
    var description: String
    var images: [TrailImage]
    var area: String
    var days: String
    var distance: String
    var state: String
    var country: String
    var trailDifficultyID: String  // Updated property name for clarity

    struct TrailImage: Codable {
        var image_name: String
    }

    enum CodingKeys: String, CodingKey {
        case trail_id
        case trail_name
        case description
        case images
        case area
        case days
        case distance
        case state
        case country
        case trailDifficultyID = "difficulty_id"  // Match with the server response
    }
}


//difficulty levels api
class DifficultyViewModel: ObservableObject {
    @Published var difficultyLevels: [DifficultyLevel] = []

    func fetchDifficultyLevels() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/getDifficultyLevels?difficulty_id=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([DifficultyLevel].self, from: JSONSerialization.data(withJSONObject: result))
                difficultyLevels = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

struct DifficultyLevel: Codable {
    var difficulty_id: String
    var name: String
}



//multiday trails api
class MulTrailViewModel: ObservableObject {
    @Published var multrails: [MultidayTrail] = []
    @Published var selectedTrail: MultidayTrail?

    func fetchData() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/multiDayTrailsExploreAll?start=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([MultidayTrail].self, from: JSONSerialization.data(withJSONObject: result))
                multrails = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }

    func selectTrail(_ trail: MultidayTrail) {
        selectedTrail = trail
    }
}




struct MultidayTrail: Codable {
    var trail_id: String
    var trail_name: String
    var description: String
    var images: [TrailImage]
    var area: String
    var days: String
    var distance: String
    var state: String
    var country: String
    var trailDifficultyID: String
    
    struct TrailImage: Codable{
        var image_name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case trail_id
        case trail_name
        case description
        case images
        case area
        case days
        case distance
        case state
        case country
        case trailDifficultyID = "difficulty_id"

    }
}


//weekend trails api
class WeekendTrailsViewModel: ObservableObject {
    @Published var weekendTrails: [WeekendTrail] = []
    @Published var selectedTrail: WeekendTrail?


    func fetchData() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/weekendTrailsExploreAll?start=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([WeekendTrail].self, from: JSONSerialization.data(withJSONObject: result))
                weekendTrails = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }
    func selectTrail(_ trail: WeekendTrail) {
        selectedTrail = trail
    }
}

struct WeekendTrail: Codable {
    var trail_id: String
    var trail_name: String
    var description: String
    var images: [TrailImage]
    var area: String
    var days: String
    var distance: String
    var state: String
    var country: String
    var trailDifficultyID: String

    struct TrailImage: Codable {
        var image_name: String
    }

    enum CodingKeys: String, CodingKey {
        case trail_id
        case trail_name
        case description
        case images
        case area
        case days
        case distance
        case state
        case country
        case trailDifficultyID = "difficulty_id"
    }
}



//login api
class LoginViewModel: ObservableObject {
    @Published var loggedInUser: LoggedInUser?
    @Published var loginError: LoginError?
    @Published var isLoggedIn: Bool = false

    func loginUser(email: String, password: String) {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/login") else {
            print("Invalid URL")
            return
        }

        let parameters: [String: String] = ["email": email, "password": password]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("Error: No data in response")
                return
            }

            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)

                if loginResponse.status == 1 {
                    self.loggedInUser = loginResponse.result
                    self.isLoggedIn = true
                } else {
                    self.loginError = LoginError(message: loginResponse.message)
                    self.isLoggedIn = false

                }
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
}

struct LoginResponse: Codable {
    var status: Int
    var message: String
    var result: LoggedInUser?
}

struct LoggedInUser: Codable {
    var user_id: String
    var email: String
    var name: String
    var city: String
    var country: String
    var profilepic: String


    

}

struct LoginError: Error {
    var message: String
}



class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    private var cancellables: Set<AnyCancellable> = []



    init() {
        print("ActivityViewModel initialized")
        fetchActivities()
    }

    func fetchActivities() {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/feed?user_id=1056") else {
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] apiResponse in
                self?.activities = apiResponse.result
            })
            .store(in: &cancellables)
    }
}

struct APIResponse: Codable {
    let status: Int
    let message: String
    let result: [Activity]
}


struct Activity: Codable, Identifiable {
    let id: String
    let name: String
    let activity_type: String
    let trail_id: String
    let difficulty_id: String
    let steps: String
    let distance: String
    let northeast: String?
    let southwest: String?
    let elapsed_time: String
    let avg_pace: String
    let avg_speed: String
    let calories: String
    let elevation_gain: String
    let start_elevation: String?
    let end_elevation: String?
    let user_id: String
    let static_map_image: String
    let total_no_of_lat_longs: String
    let created_time: String
    let createdat: String
    let endedat: String
    let isActive: String
    let isDeleted: String
    let unique_id: String
    let username: String
    let profilepic: String
    let activity_images: [ActivityImage]
    let isLiked: Int
    let likescount: String
    let likes: [Like]
    let commentscount: Int
    let comment: Comment
    let sharescount: Int
    let shareLink: String

    private enum CodingKeys: String, CodingKey {
        case id, name, activity_type, trail_id, difficulty_id, steps, distance, northeast, southwest, elapsed_time, avg_pace, avg_speed, calories, elevation_gain, start_elevation, end_elevation, user_id, static_map_image, total_no_of_lat_longs, created_time, createdat, endedat, isActive, isDeleted, unique_id, username, profilepic, activity_images, isLiked, likescount, likes, commentscount, comment, sharescount, shareLink
    }
}

struct ActivityImage: Codable {
    let image: String
}

struct Like: Codable {
    let id: String
    let post_id: String
    let user_id: String
    let isLiked: String
    let created_time: String
    let name: String
    let profilepic: String
}

struct Comment: Codable {
    let id: String
    let post_id: String
    let user_id: String
    let comment: String
    let created_time: String
    let isActive: String
    let isDeleted: String
    let name: String
    let profilepic: String
}




class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserDetails?

    init() {
        fetchData()
    }

    func fetchData() {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/getUserProfileDetails?user_id=1056&login_user_id=1056") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let userProfile = try decoder.decode(UserProfile.self, from: data)
                    DispatchQueue.main.async {
                        self.userProfile = userProfile.result
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
}

struct UserProfile: Codable {
    let status: Int
    let message: String
    let result: UserDetails
}

struct UserDetails: Codable {
    let userId: String
    let email: String
    let password: String
    let name: String
    let city: String
    let state: String
    let dob: String
    let height: String
    let weight: String
    let gender: String
    let profilePic: String
    let socialTypeFB: String?
    let fbId: String?
    let socialTypeGoogle: String?
    let googleId: String?
    let pwdToken: String?
    let country: String
    let countryCode: String
    let countryCodeName: String
    let mobile: String
    let emergencyCountryCode: String
    let emergencyCountryCodeName: String
    let emergencyMobile: String
    let relation: String
    let relationOther: String
    let role: String
    let isNotiEnable: String
    let isActive: String
    let isDeleted: String
    let lastLoginTime: String
    let lastNotiSeenTime: String
    let createdTime: String
    let sentMail: String?
    let description: String
    let isFollowing: Int
    let activities: String
    let totalDistance: Int
    let elevationGain: Int
    let following: String
    let followers: String
    let shareLink: String
    let points: Int
    let rank: Int
    let communityContributions: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case password
        case name
        case city
        case state
        case dob
        case height
        case weight
        case gender
        case profilePic = "profilepic"
        case socialTypeFB = "socialtype_fb"
        case fbId = "fb_id"
        case socialTypeGoogle = "socialtype_google"
        case googleId = "google_id"
        case pwdToken = "pwdtoken"
        case country
        case countryCode = "country_code"
        case countryCodeName = "country_code_name"
        case mobile
        case emergencyCountryCode = "emergency_country_code"
        case emergencyCountryCodeName = "emergency_country_code_name"
        case emergencyMobile = "emergency_mobile"
        case relation
        case relationOther = "relation_other"
        case role
        case isNotiEnable = "is_noti_enable"
        case isActive
        case isDeleted
        case lastLoginTime = "last_login_time"
        case lastNotiSeenTime = "last_noti_seen_time"
        case createdTime = "created_time"
        case sentMail = "sent_mail"
        case description
        case isFollowing
        case activities
        case totalDistance = "totaldistance"
        case elevationGain = "elevationgain"
        case following
        case followers
        case shareLink
        case points
        case rank
        case communityContributions = "communityContributions"
    }
}

