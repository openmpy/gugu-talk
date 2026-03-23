package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.MemberLike
import org.springframework.data.jpa.repository.JpaRepository

interface MemberLikeRepository : JpaRepository<MemberLike, Long> {

    fun findByLikerIdAndTargetId(likerId: Long, targetId: Long): MemberLike?

    fun existsByLikerIdAndTargetId(likeId: Long, targetId: Long): Boolean

    fun countByTargetId(targetId: Long): Long
}