package com.openmpy.server.member.domain.entity

import com.openmpy.server.member.domain.type.Gender
import com.openmpy.server.member.domain.type.MemberStatus
import jakarta.persistence.*
import java.time.LocalDateTime
import java.util.*

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
    val comment: String? = null,

    @Column(nullable = false)
    val likes: Long = 0,

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
}