package com.openmpy.server.member.domain.entity

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "member_block")
class MemberBlock(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blocker_id", nullable = false)
    val blocker: Member,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blocked_id", nullable = false)
    val blocked: Member,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),
)