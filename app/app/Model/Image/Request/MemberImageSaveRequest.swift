struct MemberImageSaveRequest: Encodable {

    let images: [ImageItemRequest]
    let deleteIds: [Int64]
}
