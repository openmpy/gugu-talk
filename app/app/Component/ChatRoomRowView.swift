import SwiftUI
import Kingfisher

struct ChatRoomRowView: View {

    let thumbnail: String?
    let nickname: String
    let lastMessageAt: String
    let lastMessage: String
    let unreadCount: Int64

    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: thumbnail ?? ""))
                .resizable()
                .placeholder {
                    Image(systemName: "person.fill")
                        .font(.title)
                        .frame(width: 55, height: 55)
                        .foregroundColor(Color(.systemGray6))
                        .background(Color(.systemGray4))
                        .clipShape(Circle())
                }
                .font(.title)
                .frame(width: 55, height: 55)
                .foregroundColor(Color(.systemGray6))
                .background(Color(.systemGray4))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(nickname)
                        .font(.headline.bold())
                        .foregroundColor(.primary)

                    Spacer()

                    Text(lastMessageAt.customFormattedTime)
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                }

                HStack(alignment: .center) {
                    Text(lastMessage.byCharWrapping)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.leading)

                    Spacer()

                    if unreadCount > 0 {
                        Text(unreadCount > 99 ? "99+" : "\(unreadCount)")
                            .font(.caption2)
                            .foregroundColor(Color(.systemBackground))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray2))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
