package com.openmpy.server.image.domain.type

import com.fasterxml.jackson.annotation.JsonCreator

enum class MemberImageType {

    PUBLIC,
    PRIVATE;

    companion object {

        @JsonCreator
        @JvmStatic
        fun from(value: String): MemberImageType {
            return MemberImageType.entries.find { it.name.equals(value, ignoreCase = true) }
                ?: throw IllegalArgumentException("유효하지 않은 이미지 타입입니다. ($value)")
        }
    }
}