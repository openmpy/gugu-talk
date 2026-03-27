import SwiftUI

struct MemberProfileInfoView: View {

    let nickname: String
    let gender: String
    let updatedAt: String?
    let bio: String?
    let age: Int
    let likes: Int64
    let distance: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center) {
                Text(nickname)
                    .font(.title.bold())

                Spacer()

                if let updatedAt = updatedAt {
                    Text(updatedAt.relativeTime)
                        .font(.callout)
                        .foregroundColor(Color(.systemGray))
                }
            }
            HStack(alignment: .center) {
                HStack {
                    Text(gender == "MALE" ? "남자" : "여자")
                    Text("·")
                    Text("\(age)살")
                    Text("·")
                    Text("♥ \(likes)")
                }
                .font(.callout)
                .foregroundColor(Color(.systemGray))

                Spacer()

                if let distance = distance {
                    Text(String(format: "%.1f", distance) + "km")
                        .font(.callout)
                        .foregroundColor(Color(.systemGray))
                }
            }
            Text(bio ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
}
