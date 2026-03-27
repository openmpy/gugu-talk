package com.openmpy.server.report.domain.type

import com.fasterxml.jackson.annotation.JsonCreator

enum class ReportType {

    ABUSE,
    SPAM,
    MINOR,
    SEXUAL,
    FAKE,
    ETC;

    companion object {

        @JsonCreator
        @JvmStatic
        fun from(value: String): ReportType {
            return ReportType.entries.find { it.name.equals(value, ignoreCase = true) }
                ?: throw IllegalArgumentException("잘못된 신고 유형입니다. ($value)")
        }
    }
}