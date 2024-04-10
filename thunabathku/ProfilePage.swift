import SwiftUI

struct ProfilePage: View {
    @ObservedObject var viewModel = UserProfileViewModel()
    @State private var useImperialSystem = false

    var body: some View {
        ScrollView {
            VStack {
                if let userProfile = viewModel.userProfile {
                    AsyncImage(url: URL(string: userProfile.profilePic)) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            //.padding()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }

                    Text(userProfile.name)
                        .font(.title)
                        .foregroundColor(.orange)
                        .fontWeight(.bold)
                        //.padding(.top, 10)

                    Text("\(userProfile.city), \(userProfile.country)")
                        //.font(.subheadline)
                        .foregroundColor(Color.gray)
                        .padding(.top, 5)

                    HStack {
                        VStack {
                            Text("\(userProfile.followers)")
                                .font(.headline)
                                .foregroundColor(.orange)
                            Text("Followers")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Divider()
                            .frame(height: 40)
                            .background(Color.gray)

                        VStack {
                            Text("\(userProfile.following)")
                                .font(.headline)
                                .foregroundColor(.orange)
                            Text("Following")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 10)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                            ProfileDetailRow(label: "Activities", value: "\(userProfile.activities)", systemImageName: "figure.gymnastics")
                                            ProfileDetailRow(label: "Total Distance", value: "\(userProfile.totalDistance) km", systemImageName: "point.fill.topleft.down.curvedto.point.fill.bottomright.up")
                                            ProfileDetailRow(label: "Community Contributions", value: "\(userProfile.communityContributions)", systemImageName: "hands.clap.fill")
                                            ProfileDetailRow(label: "Elevation Gained", value: "\(userProfile.elevationGain) m", systemImageName: "mountain.2.fill")
                                            ProfileDetailRow(label: "Points Gained", value: "\(userProfile.points)", systemImageName: "star.fill")
                                            ProfileDetailRow(label: "Leaderboard", value: "#\(userProfile.rank)", systemImageName: "rosette")
                                        }
                                        .padding(.top, 10)
                                        .padding(.leading, 15)
                                        /*.overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.orange, lineWidth: 2)
                                        )*/

                    // Rectangle with shadows, text, and toggle button
                    Rectangle()
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .frame(height: 50)
                        .padding([.leading, .trailing], 20)
                        .overlay(
                            HStack {
                                Image(systemName: "ruler")
                                    .foregroundColor(.orange)
                                    .padding(.leading, 25)

                                Text("Use Imperial system(miles / feet)")
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)

                                Spacer()

                                Toggle("", isOn: $useImperialSystem)
                                    .padding(.trailing, 25)
                            }
                        )
                        .padding(.top, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            Card(title: "All", systemName: "")
                            Card(title: "Hiking", systemName: "figure.hiking")
                            Card(title: "Cycling", systemName: "bicycle")
                            Card(title: "Running", systemName: "figure.run")
                            Card(title: "Walking", systemName: "figure.walk")
                            Card(title: "Motor Biking", systemName: "m.circle")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                    }
                    .padding(.top, 20)

                } else {
                    ProgressView("Loading...")
                }
            }
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}


struct ProfileDetailRow: View {
    var label: String
    var value: String
    var systemImageName: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImageName)
                .foregroundColor(.orange)
                .frame(width: 20, height: 20)
                .padding(.trailing, 8)

            VStack(alignment: .center) {
                Text(label + ":")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(value)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
struct Card: View {
    var title: String
    var systemName: String

    var body: some View {
        VStack {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.orange)
            Text(title)
                .font(.headline)
                .foregroundColor(.orange)
                .padding(.bottom, 5)
        }
        .frame(width: 170, height: 90)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
