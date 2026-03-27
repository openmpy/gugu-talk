import SwiftUI

struct ChatMessageRowView: View {

    let memberId: Int64
    let targetId: Int64
    let content: String
    let createdAt: String

    var body: some View {
        if (memberId != targetId) {
            HStack(alignment: .bottom, spacing: 5) {
                Text(content.byCharWrapping)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Text(createdAt.ampmTime)
                    .font(.caption2)
                    .foregroundColor(.gray)

                Spacer()
            }
        } else {
            HStack(alignment: .bottom, spacing: 5) {
                Spacer()

                Text(createdAt.ampmTime)
                    .font(.caption2)
                    .foregroundColor(.gray)

                Text(content.byCharWrapping)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}
