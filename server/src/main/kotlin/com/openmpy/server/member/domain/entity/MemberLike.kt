package com.openmpy.server.member.domain.entity

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(
    name = "member_like",
    uniqueConstraints = [UniqueConstraint(columnNames = ["liker_id", "target_id"])]
)
class MemberLike(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false)
    val likerId: Long,

    @Column(nullable = false)
    val targetId: Long,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),
)