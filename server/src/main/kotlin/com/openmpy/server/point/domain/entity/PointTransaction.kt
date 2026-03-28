package com.openmpy.server.point.domain.entity

import com.openmpy.server.point.domain.type.PointSource
import com.openmpy.server.point.domain.type.TransactionType
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "point_transaction")
class PointTransaction(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false)
    val memberId: Long,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    val type: TransactionType,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    val source: PointSource,

    @Column(nullable = false)
    var amount: Long = 0,

    @Column(nullable = false)
    var balanceSnapshot: Long = 0,

    @Column
    var description: String?,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(nullable = false)
    var updatedAt: LocalDateTime = LocalDateTime.now(),
)