package com.openmpy.server.member.repository

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.domain.entity.MemberPrivatePhoto
import org.springframework.data.jpa.repository.JpaRepository

interface MemberPrivatePhotoRepository : JpaRepository<MemberPrivatePhoto, Long> {

    fun findByOwnerAndTarget(owner: Member, target: Member): MemberPrivatePhoto?

    fun existsByOwnerAndTarget(owner: Member, target: Member): Boolean
}