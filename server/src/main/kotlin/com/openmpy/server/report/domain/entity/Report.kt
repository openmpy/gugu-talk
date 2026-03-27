package com.openmpy.server.report.domain.entity

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.report.domain.type.ReportStatus
import com.openmpy.server.report.domain.type.ReportType
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "report")
class Report(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reporter_id", nullable = false)
    val reporter: Member,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reported_id", nullable = false)
    val reported: Member,

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    val status: ReportStatus = ReportStatus.PENDING,

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    val type: ReportType,

    @Column(name = "reason", columnDefinition = "TEXT")
    val reason: String?,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),
)