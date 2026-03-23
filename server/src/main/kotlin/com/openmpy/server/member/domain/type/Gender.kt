package com.openmpy.server.member.domain.type

import com.fasterxml.jackson.annotation.JsonCreator

enum class Gender {

    MALE,
    FEMALE;

    companion object {
        @JsonCreator
        @JvmStatic
        fun from(value: String): Gender {
            return entries.find { it.name.equals(value, ignoreCase = true) }
                ?: throw IllegalArgumentException("찾을 수 없는 성별 값입니다. ($value)")
        }
    }
}