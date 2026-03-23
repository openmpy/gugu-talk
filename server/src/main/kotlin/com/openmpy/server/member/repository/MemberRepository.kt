package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.Member
import org.springframework.data.jpa.repository.JpaRepository

interface MemberRepository : JpaRepository<Member, Long> {

    fun existsByPhone(phone: String): Boolean
}