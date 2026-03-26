import SwiftUI

struct MemberSearchRowView: View {

    let nickname: String
    let gender: String
    let updatedAt: String
    let age: Int
    let likes: Int64

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.fill")
                .font(.title)
                .frame(width: 55, height: 55)
                .foregroundColor(Color(.systemGray6))
                .background(Color(.systemGray4))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(nickname)
                        .font(.headline.bold())
                        .foregroundColor(gender == "MALE" ? .blue : .pink)

                    Spacer()

                    Text(updatedAt.relativeTime)
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                }

                HStack {
                    Text(gender == "MALE" ? "남자" : "여자")
                    Text("·")
                    Text("\(age)살")
                    Text("·")
                    Text("♥ \(likes)")
                }
                .font(.footnote)
                .foregroundColor(Color(.systemGray))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
