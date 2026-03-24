package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.domain.entity.MemberBlock
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface MemberBlockRepository : JpaRepository<MemberBlock, Long> {

    fun findByBlockerAndBlocked(blocker: Member, blocked: Member): MemberBlock?

    fun existsByBlockerAndBlocked(blocker: Member, blocked: Member): Boolean

    @Query(
        value = """
            SELECT b
            FROM MemberBlock b
            WHERE b.blocker.id = :memberId
                AND (:cursorId IS NULL OR b.id < :cursorId)
            ORDER BY b.id DESC
        """
    )
    fun findBlockedMembers(
        @Param("memberId") memberId: Long,
        @Param("cursorId") cursorId: Long?,
        pageable: Pageable
    ): List<MemberBlock>
}