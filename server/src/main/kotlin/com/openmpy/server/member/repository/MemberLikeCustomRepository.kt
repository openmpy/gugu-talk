package com.openmpy.server.member.repository

import com.openmpy.server.member.repository.dto.MemberSettingResult

interface MemberLikeCustomRepository {

    fun findByLikerIdWithCursor(
        likerId: Long,
        cursorId: Long?,
        limit: Int
    ): List<MemberSettingResult>
}