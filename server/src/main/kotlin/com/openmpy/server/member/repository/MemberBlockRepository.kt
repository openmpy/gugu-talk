package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.domain.entity.MemberBlock
import org.springframework.data.jpa.repository.JpaRepository

interface MemberBlockRepository : JpaRepository<MemberBlock, Long> {

    fun findByBlockerAndBlocked(blocker: Member, blocked: Member): MemberBlock?

    fun existsByBlockerAndBlocked(blocker: Member, blocked: Member): Boolean
}