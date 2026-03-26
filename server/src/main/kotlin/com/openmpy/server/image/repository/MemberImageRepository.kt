package com.openmpy.server.image.repository

import com.openmpy.server.image.domain.entity.MemberImage
import org.springframework.data.jpa.repository.JpaRepository

interface MemberImageRepository : JpaRepository<MemberImage, Long> {

    fun findAllByMemberIdAndIdIn(memberId: Long, ids: List<Long>): List<MemberImage>

    fun findAllByMemberId(memberId: Long): List<MemberImage>
}