package com.openmpy.server.member.repository

import com.openmpy.server.member.repository.projection.MemberSettingProjection

interface MemberLikeCustomRepository {

    fun findByLikerIdWithCursor(
        likerId: Long,
        cursorId: Long?,
        limit: Int
    ): List<MemberSettingProjection>
}