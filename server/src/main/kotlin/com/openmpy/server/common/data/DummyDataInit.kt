package com.openmpy.server.common.data

import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.domain.type.Gender
import com.openmpy.server.member.domain.type.MemberStatus
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.boot.CommandLineRunner
import org.springframework.context.annotation.Bean
import org.springframework.stereotype.Component
import java.util.*

@Component
class DummyDataInit {

    @Bean
    fun init(memberRepository: MemberRepository): CommandLineRunner {
        return CommandLineRunner {
            if (memberRepository.count() == 0L) {
                val members = (0 until 100).map { i ->
                    Member(
                        uuid = UUID.randomUUID().toString(),
                        phone = "01000000%03d".format(i),
                        password = "1234",
                        status = MemberStatus.ACTIVE,
                        gender = if (i % 2 == 0) Gender.MALE else Gender.FEMALE,
                        birthYear = 1920 + i,
                        bio = "반갑습니다 $i",
                        comment = "감사합니다 $i",
                        likes = i.toLong()
                    )
                }

                memberRepository.saveAll(members)
                println("회원 데이터가 생성되었습니다. (${memberRepository.count()}개)")
            }
        }
    }
}