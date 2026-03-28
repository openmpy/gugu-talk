package com.openmpy.server.point.domain.entity

import com.openmpy.server.common.exception.CustomException
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "point")
class Point(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(unique = true, nullable = false)
    val memberId: Long,

    @Column(nullable = false)
    var balance: Long = 0,

    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(nullable = false)
    var updatedAt: LocalDateTime = LocalDateTime.now(),
) {

    fun earn(amount: Long) {
        if (amount <= 0) {
            throw CustomException("적립 금액은 0보다 커야 합니다.")
        }

        this.balance += amount
        this.updatedAt = LocalDateTime.now()
    }

    fun use(amount: Long) {
        if (amount <= 0) {
            throw CustomException("사용 금액은 0보다 커야 합니다.")
        }
        if (this.balance < amount) {
            throw CustomException("포인트가 부족합니다.")
        }

        this.balance -= amount
        this.updatedAt = LocalDateTime.now()
    }
}