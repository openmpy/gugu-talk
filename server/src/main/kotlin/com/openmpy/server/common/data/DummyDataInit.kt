package com.openmpy.server.common.data

import com.openmpy.server.chat.repository.ChatMessageRepository
import com.openmpy.server.chat.repository.ChatRoomRepository
import com.openmpy.server.member.domain.entity.Member
import com.openmpy.server.member.domain.type.Gender
import com.openmpy.server.member.domain.type.MemberStatus
import com.openmpy.server.member.repository.MemberBlockRepository
import com.openmpy.server.member.repository.MemberLikeRepository
import com.openmpy.server.member.repository.MemberPrivatePhotoRepository
import com.openmpy.server.member.repository.MemberRepository
import org.locationtech.jts.geom.Coordinate
import org.locationtech.jts.geom.GeometryFactory
import org.springframework.boot.CommandLineRunner
import org.springframework.context.annotation.Bean
import org.springframework.stereotype.Component
import java.util.*

@Component
class DummyDataInit {

    @Bean
    fun init(
        memberRepository: MemberRepository,
        memberLikeRepository: MemberLikeRepository,
        memberPrivatePhotoRepository: MemberPrivatePhotoRepository,
        memberBlockRepository: MemberBlockRepository,
        chatRoomRepository: ChatRoomRepository,
        chatMessageRepository: ChatMessageRepository,
    ): CommandLineRunner {
        return CommandLineRunner {
            // 회원
            if (memberRepository.count() == 0L) {
                val geometryFactory = GeometryFactory()

                val members = (0 until 100).map { i ->
                    val latitude = 37.5665 + (Math.random() - 0.5) * 0.1
                    val longitude = 126.9780 + (Math.random() - 0.5) * 0.1
                    val point = geometryFactory.createPoint(Coordinate(longitude, latitude))
                    point.srid = 4326

                    Member(
                        uuid = UUID.randomUUID().toString(),
                        phone = "01000000%03d".format(i),
                        nickname = "닉네임$i",
                        password = "1234",
                        status = MemberStatus.ACTIVE,
                        gender = if (i % 2 == 0) Gender.MALE else Gender.FEMALE,
                        birthYear = 1920 + i / 2,
                        bio = "반갑습니다 $i",
                        comment = "감사합니다 $i",
                        likes = i.toLong(),
                        location = point
                    )
                }
                memberRepository.saveAll(members)
                println("회원 데이터가 생성되었습니다. (${memberRepository.count()}개)")
            }

            // 회원 좋아요
//            if (memberLikeRepository.count() == 0L) {
//                val memberLikes = (2 until 100).map { i ->
//                    MemberLike(
//                        likerId = 1,
//                        targetId = i.toLong()
//                    )
//                }
//                memberLikeRepository.saveAll(memberLikes)
//                println("회원 좋아요 데이터가 생성되었습니다. ${memberLikeRepository.count()}")
//            }

            // 회원 비밀 사진
//            if (memberPrivatePhotoRepository.count() == 0L) {
//                val member = memberRepository.findById(1).get()
//
//                val memberPrivatePhoto = (2 until 100).map { i ->
//                    MemberPrivatePhoto(
//                        owner = member,
//                        target = memberRepository.findById(i.toLong()).get()
//                    )
//                }
//                memberPrivatePhotoRepository.saveAll(memberPrivatePhoto)
//                println("회원 비밀 사진 데이터가 생성되었습니다. ${memberLikeRepository.count()}")
//            }

            // 회원 차단
//            if (memberBlockRepository.count() == 0L) {
//                val member = memberRepository.findById(1).get()
//
//                val memberBlock = (2 until 100).map { i ->
//                    MemberBlock(
//                        blocker = member,
//                        blocked = memberRepository.findById(i.toLong()).get()
//                    )
//                }
//                memberBlockRepository.saveAll(memberBlock)
//                println("회원 차단 데이터가 생성되었습니다. ${memberBlockRepository.count()}")
//            }

            // 채팅방
//            if (chatRoomRepository.count() == 0L) {
//                val chatRooms = (2 until 100).map { i ->
//                    ChatRoom(
//                        member1Id = 1,
//                        member2Id = i.toLong(),
//                        lastMessage = "안녕하세요$i",
//                        member2LastReadMessageId = i.toLong(),
//                        lastMessageAt = LocalDateTime.of(
//                            2025,
//                            Month.DECEMBER,
//                            21,
//                            22,
//                            0
//                        ).plusMinutes(i.toLong()),
//                    )
//                }
//                chatRoomRepository.saveAll(chatRooms)
//                println("채팅방 데이터가 생성되었습니다. ${chatRoomRepository.count()}")
//            }

            // 메시지
//            if (chatMessageRepository.count() == 0L) {
//                val chatMessages = (1 until 100).map { i ->
//                    ChatMessage(
//                        chatRoomId = 1L,
//                        senderId = 1L,
//                        content = "날씨가 맑아요 $i",
//                    )
//                }
//                chatMessageRepository.saveAll(chatMessages)
//                println("채팅 메시지 데이터가 생성되었습니다. ${chatMessageRepository.count()}")
//            }
        }
    }
}