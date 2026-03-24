package com.openmpy.server.member.repository.projection

import com.openmpy.server.member.domain.type.Gender
import java.time.LocalDateTime

interface MemberWithDistanceProjection {

    val id: Long
    val nickname: String
    val comment: String?
    val bio: String?
    val gender: Gender
    val birthYear: Int
    val likes: Long
    val distance: Double?
    val updatedAt: LocalDateTime
}
