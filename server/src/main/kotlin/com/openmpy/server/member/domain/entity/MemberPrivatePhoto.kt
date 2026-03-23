package com.openmpy.server.member.domain.entity

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "members_private_photo")
class MemberPrivatePhoto(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    val owner: Member,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_id", nullable = false)
    val target: Member,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),
)