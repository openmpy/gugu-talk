package com.openmpy.server.member.domain.entity

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.domain.type.Gender
import com.openmpy.server.member.domain.type.MemberStatus
import jakarta.persistence.*
import org.locationtech.jts.geom.Point
import java.time.LocalDateTime
import java.util.*

private const val DEFAULT_COMMENT = "반갑습니다."

@Entity
@Table(name = "member")
class Member(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(unique = true, nullable = false)
    val uuid: String,

    @Column(unique = true, nullable = false)
    val phone: String,

    @Column(nullable = false)
    val password: String,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    val status: MemberStatus = MemberStatus.ACTIVE,

    @Column(unique = true, nullable = false)
    var nickname: String = UUID.randomUUID().toString()
        .replace("-", "")
        .substring(0, 10),

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    val gender: Gender,

    @Column(nullable = false)
    var birthYear: Int = 2000,

    @Column
    var bio: String? = null,

    @Column
    var comment: String? = null,

    @Column(columnDefinition = "geography(Point,4326)")
    var location: Point? = null,

    @Column
    var isChatEnabled: Boolean = true,

    @Column(nullable = false)
    var likes: Long = 0,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(nullable = false)
    var updatedAt: LocalDateTime = LocalDateTime.now(),

    @Column
    val deletedAt: LocalDateTime? = null
) {

    fun setup(nickname: String, birthYear: Int, bio: String) {
        this.nickname = nickname
        this.birthYear = birthYear
        this.bio = bio
        this.updatedAt = LocalDateTime.now()
    }

    fun updateComment(comment: String) {
        this.comment = comment
        this.updatedAt = LocalDateTime.now()
    }

    fun bumpComment() {
        if (this.comment.isNullOrBlank()) {
            this.comment = DEFAULT_COMMENT
        }
        this.updatedAt = LocalDateTime.now()
    }

    fun updateLocation(location: Point?) {
        this.location = location
        this.updatedAt = LocalDateTime.now()
    }

    fun updateChatEnabled(enabled: Boolean) {
        this.isChatEnabled = enabled
    }

    fun increaseLike() {
        this.likes += 1
    }

    fun decreaseLike() {
        if (this.likes <= 0) {
            throw CustomException("좋아요 수는 0 이하가 될 수 없습니다.")
        }

        this.likes -= 1
    }

    fun updateProfile(nickname: String, birthYear: Int, bio: String?) {
        this.nickname = nickname
        this.birthYear = birthYear
        this.bio = bio
    }
}