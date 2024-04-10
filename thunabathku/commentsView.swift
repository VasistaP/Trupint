import SwiftUI

func jsonDecodedString(from string: String) -> String {
    let quotedString = "\"\(string)\""
    guard let data = quotedString.data(using: .utf8),
          let decodedString = try? JSONDecoder().decode(String.self, from: data) else {
        return string // Return the original string if decoding fails
    }
    return decodedString
}


struct CommentsView: View {
    @StateObject var viewModel = CommentsViewModel()
    let postId: String
    @Environment(\.presentationMode) var presentationMode

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

                    Text("Comments")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(.leading, 10)

                    Spacer()
                }
                .padding(.top, 40)
                .frame(height: 100)

                ScrollView {
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) { // Align VStack contents to the leading edge
                        ForEach(viewModel.comments) { comment in
                            HStack(alignment: .top, spacing: 10) {
                                AsyncImage(url: comment.profilePic) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView().frame(width: 50, height: 50)
                                    case .success(let image):
                                        image.resizable()
                                             .aspectRatio(contentMode: .fill)
                                             .frame(width: 50, height: 50)
                                             .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .background(Color.gray)
                                            .clipShape(Circle())
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                                VStack(alignment: .leading, spacing: 5) { // Align VStack contents to the leading
                                    Text(comment.name)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left

                                    Text(jsonDecodedString(from: comment.comment))
                                        .fixedSize(horizontal: false, vertical: true) // Allow text to wrap
                                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // Ensure HStack aligns its content to the leading edge
                            .padding()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Task {
                await viewModel.fetchComments(forPostId: postId)
            }
        }
    }
}
