package com.openmpy.server.point.repository

import com.openmpy.server.point.domain.entity.Point
import jakarta.persistence.LockModeType
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Lock
import org.springframework.data.jpa.repository.Query

interface PointRepository : JpaRepository<Point, Long> {

    fun findByMemberId(memberId: Long): Point?

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query(
        value = """
            SELECT p
            FROM Point p
            WHERE p.memberId = :memberId
        """
    )
    fun findByMemberIdWithLock(memberId: Long): Point?
}