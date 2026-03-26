import SwiftUI

struct MemberSettingRowView: View {

    let nickname: String
    let gender: String
    let age: Int
    let onDelete: () async -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.fill")
                .font(.title)
                .frame(width: 55, height: 55)
                .foregroundColor(Color(.systemGray6))
                .background(Color(.systemGray4))
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(nickname)
                    .font(.headline.bold())
                    .foregroundColor(.primary)

                HStack {
                    Text(gender == "MALE" ? "남자" : "여자")
                    Text("·")
                    Text("\(age)살")
                }
                .font(.footnote)
                .foregroundColor(Color(.systemGray))
            }

            Spacer()

            Button {
                Task {
                    await onDelete()
                }
            } label: {
                Image(systemName: "trash.fill")
                    .font(.default)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .background(.red)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
