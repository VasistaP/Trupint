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
    
    init() {
            // Nothing specific here; could be used to initialize default states or perform checks
        }
    
    init(loggedInUser: LoggedInUser?) {
            self.loggedInUser = loggedInUser
        }

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
    private var loggedInUser: LoggedInUser?

    // Default init method.
    init() {
        print("ActivityViewModel initialized")
    }

    // Method to update the logged-in user and fetch activities.
    func update(loggedInUser: LoggedInUser?) {
        self.loggedInUser = loggedInUser
        if loggedInUser != nil {
            fetchActivities()
        } else {
            activities = []
        }
    }

    func fetchActivities() {
        guard let user_id = loggedInUser?.user_id else {
            print("Error: User ID is unavailable")
            return
        }
        
        let urlString = "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/feed?user_id=\(user_id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Print statement could also be placed here for debugging completion state.
                    break
                case .failure(let error):
                    print("Error during data task operation: \(error)")
                }
            }, receiveValue: { [weak self] apiResponse in
                self?.activities = apiResponse.result
                // Debug print for checking comments
                self?.activities.forEach { activity in
                    if let comment = activity.comment {
                        print("Fetched Comment for Activity ID \(activity.id): \(comment.comment)")
                    } else {
                        print("No comment for Activity ID: \(activity.id)")
                    }
                }
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
    let static_map_image: String?
    let total_no_of_lat_longs: String?
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
    let likescount: Int
    let likes: [Like]
    let commentscount: Int
    let comment: Comment?
    let sharescount: Int
    let shareLink: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        activity_type = try container.decode(String.self, forKey: .activity_type)
        trail_id = try container.decode(String.self, forKey: .trail_id)
        difficulty_id = try container.decode(String.self, forKey: .difficulty_id)
        steps = try container.decode(String.self, forKey: .steps)
        distance = try container.decode(String.self, forKey: .distance)
        northeast = try container.decodeIfPresent(String.self, forKey: .northeast)
        southwest = try container.decodeIfPresent(String.self, forKey: .southwest)
        elapsed_time = try container.decode(String.self, forKey: .elapsed_time)
        avg_pace = try container.decode(String.self, forKey: .avg_pace)
        avg_speed = try container.decode(String.self, forKey: .avg_speed)
        calories = try container.decode(String.self, forKey: .calories)
        elevation_gain = try container.decode(String.self, forKey: .elevation_gain)
        start_elevation = try container.decodeIfPresent(String.self, forKey: .start_elevation)
        end_elevation = try container.decodeIfPresent(String.self, forKey: .end_elevation)
        user_id = try container.decode(String.self, forKey: .user_id)
        static_map_image = try container.decodeIfPresent(String.self, forKey: .static_map_image)
        total_no_of_lat_longs = try container.decodeIfPresent(String.self, forKey: .total_no_of_lat_longs)
        created_time = try container.decode(String.self, forKey: .created_time)
        createdat = try container.decode(String.self, forKey: .createdat)
        endedat = try container.decode(String.self, forKey: .endedat)
        isActive = try container.decode(String.self, forKey: .isActive)
        isDeleted = try container.decode(String.self, forKey: .isDeleted)
        unique_id = try container.decode(String.self, forKey: .unique_id)
        username = try container.decode(String.self, forKey: .username)
        profilepic = try container.decode(String.self, forKey: .profilepic)
        activity_images = try container.decode([ActivityImage].self, forKey: .activity_images)
        isLiked = try container.decode(Int.self, forKey: .isLiked)

        // Custom decoding for 'likescount'
        if let likesCountString = try? container.decode(String.self, forKey: .likescount) {
            if let likesCountInt = Int(likesCountString) {
                likescount = likesCountInt
            } else {
                throw DecodingError.dataCorruptedError(forKey: .likescount, in: container, debugDescription: "likescount is not a valid integer string")
            }
        } else {
            likescount = try container.decode(Int.self, forKey: .likescount)
        }
        if let commentDictionary = try? container.decodeIfPresent([String: Comment].self, forKey: .comment) {
            comment = commentDictionary["comment"] // This case might not be necessary based on your JSON structure.
        } else {
            do {
                comment = try container.decodeIfPresent(Comment.self, forKey: .comment)
            } catch DecodingError.typeMismatch {
                // The JSON field is an array (likely empty), not a Comment object.
                comment = nil
            } catch {
                // Handle or throw any other errors.
                throw error
            }
        }


        likes = try container.decode([Like].self, forKey: .likes)
        commentscount = try container.decode(Int.self, forKey: .commentscount)
       // comment = try container.decode(Comment.self, forKey: .comment)
        sharescount = try container.decode(Int.self, forKey: .sharescount)
        shareLink = try container.decode(String.self, forKey: .shareLink)
    }


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






class ActivityDetailViewModel: ObservableObject {
    @Published var activityDetail: ActivityDetail? // Now expecting a single activity detail object
    private var cancellables: Set<AnyCancellable> = []
    private let activityId: String

    init(activityId: String) {
        self.activityId = activityId
        fetchActivities()
    }

    func fetchActivities() {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/summaryByActivityId?activity_id=\(activityId)") else {
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: detAPIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] apiResponse in
                self?.activityDetail = apiResponse.result // Assuming result is a single ActivityDetail object
            })
            .store(in: &cancellables)
    }
}


struct detAPIResponse: Codable {
    let status: Int
    let message: String
    let result: ActivityDetail // Here, assuming 'result' contains a single ActivityDetail object
}


struct ActivityDetail: Codable, Identifiable {
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
    let calories: Float?
    let elevation_gain: String
    let start_elevation: String?
    let end_elevation: String?
    let min_elevation: String?
    let max_elevation: String?
    let user_id: String
    let static_map_image: String?
    let total_no_of_lat_longs: String?
    let created_time: String
    let createdat: String
    let endedat: String
    let isActive: String
    let isDeleted: String
    let unique_id: String
    let username: String
    let profilepic: String
    let activity_images: [detActivityImage]
    let difficulty_name: String
    let points: String
   
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        activity_type = try container.decode(String.self, forKey: .activity_type)
        trail_id = try container.decode(String.self, forKey: .trail_id)
        difficulty_id = try container.decode(String.self, forKey: .difficulty_id)
        steps = try container.decode(String.self, forKey: .steps)
        distance = try container.decode(String.self, forKey: .distance)
        northeast = try container.decodeIfPresent(String.self, forKey: .northeast)
        southwest = try container.decodeIfPresent(String.self, forKey: .southwest)
        elapsed_time = try container.decode(String.self, forKey: .elapsed_time)
        avg_pace = try container.decode(String.self, forKey: .avg_pace)
        avg_speed = try container.decode(String.self, forKey: .avg_speed)
        calories = try container.decode(Float.self, forKey: .calories)
        elevation_gain = try container.decode(String.self, forKey: .elevation_gain)
        start_elevation = try container.decodeIfPresent(String.self, forKey: .start_elevation)
        end_elevation = try container.decodeIfPresent(String.self, forKey: .end_elevation)
        user_id = try container.decode(String.self, forKey: .user_id)
        static_map_image = try container.decodeIfPresent(String.self, forKey: .static_map_image)
        total_no_of_lat_longs = try container.decodeIfPresent(String.self, forKey: .total_no_of_lat_longs)
        created_time = try container.decode(String.self, forKey: .created_time)
        createdat = try container.decode(String.self, forKey: .createdat)
        endedat = try container.decode(String.self, forKey: .endedat)
        isActive = try container.decode(String.self, forKey: .isActive)
        isDeleted = try container.decode(String.self, forKey: .isDeleted)
        unique_id = try container.decode(String.self, forKey: .unique_id)
        username = try container.decode(String.self, forKey: .username)
        profilepic = try container.decode(String.self, forKey: .profilepic)
        activity_images = try container.decode([detActivityImage].self, forKey: .activity_images)
        min_elevation = try container.decodeIfPresent(String.self, forKey: .min_elevation)
        max_elevation = try container.decodeIfPresent(String.self, forKey: .max_elevation)
        difficulty_name = try container.decode(String.self, forKey: .difficulty_name)
        points = try container.decode(String.self, forKey: .points)
        
    }


    private enum CodingKeys: String, CodingKey {
        case id, name, activity_type, trail_id, difficulty_id, steps, distance
        case northeast = "Northeast", southwest = "Southwest" // Adjust casing to match JSON
        case elapsed_time, avg_pace, avg_speed, calories, elevation_gain
        case start_elevation, end_elevation, user_id, static_map_image
        case total_no_of_lat_longs, created_time, createdat, endedat
        case isActive, isDeleted, unique_id, username, profilepic, activity_images
        case min_elevation, max_elevation, difficulty_name, points
    }

    
    
}

struct detActivityImage: Codable {
    let image: String
}


class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var noCommentsMessage: String?

    struct CommentsResponse: Codable {
        let status: Int
        let message: String
        let result: [Comment]?
    }

    struct Comment: Identifiable, Codable {
        let id: String
        let postId: String
        let userId: String
        let comment: String
        let createdTime: String
        let isActive: String
        let isDeleted: String
        let name: String
        let profilePic: URL

        enum CodingKeys: String, CodingKey {
            case id
            case postId = "post_id"
            case userId = "user_id"
            case comment
            case createdTime = "created_time"
            case isActive
            case isDeleted
            case name
            case profilePic = "profilepic"
        }
    }

    func fetchComments(forPostId postId: String) async {
        let urlString = "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/getAllComments?post_id=\(postId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(CommentsResponse.self, from: data)
            if response.status == 1, let result = response.result {
                DispatchQueue.main.async {
                    self.comments = result
                }
            } else {
                DispatchQueue.main.async {
                    self.noCommentsMessage = "No comments available"
                }
            }
        } catch {
            print("Error fetching or decoding data: \(error)")
        }
    }
}
