package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.domain.entity.MemberPrivatePhoto
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface MemberPrivatePhotoRepository : JpaRepository<MemberPrivatePhoto, Long> {

    fun findByOwnerAndTarget(owner: Member, target: Member): MemberPrivatePhoto?

    fun existsByOwnerAndTarget(owner: Member, target: Member): Boolean

    @Query(
        value = """
            SELECT p
            FROM MemberPrivatePhoto p
            WHERE p.owner.id = :memberId
                AND (:cursorId IS NULL OR p.id < :cursorId)
            ORDER BY p.id DESC
        """
    )
    fun findTargetMembers(
        @Param("memberId") memberId: Long,
        @Param("cursorId") cursorId: Long?,
        pageable: Pageable
    ): List<MemberPrivatePhoto>
}