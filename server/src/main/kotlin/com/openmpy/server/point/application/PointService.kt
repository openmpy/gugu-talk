package com.openmpy.server.point.application

import com.openmpy.server.common.constants.AppConstants.Point
import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.repository.MemberRepository
import com.openmpy.server.point.domain.entity.PointTransaction
import com.openmpy.server.point.domain.type.PointSource
import com.openmpy.server.point.domain.type.TransactionType
import com.openmpy.server.point.dto.response.PointGetResponse
import com.openmpy.server.point.repository.PointRepository
import com.openmpy.server.point.repository.PointTransactionRepository
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.Duration
import java.time.LocalDate
import java.time.ZoneId
import java.time.ZonedDateTime

private const val ATTENDANCE_KEY = "point:attendance:member:"
private const val AD_REWARD_KEY = "point:ad-reward:member:"

@Service
class PointService(

    private val pointRepository: PointRepository,
    private val pointTransactionRepository: PointTransactionRepository,
    private val memberRepository: MemberRepository,
    private val redisTemplate: StringRedisTemplate
) {

    @Transactional
    fun earnByAttendance(
        memberId: Long
    ) {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")
        val point = pointRepository.findByMemberIdWithLock(memberId)
            ?: throw CustomException("포인트 정보가 없습니다.")

        val attendanceKey = ATTENDANCE_KEY + memberId
        if (redisTemplate.opsForValue().get(attendanceKey) != null) {
            throw CustomException("오늘 이미 출석 체크를 완료했습니다.")
        }

        point.earn(Point.ATTENDANCE)

        val pointTransaction = PointTransaction(
            memberId = memberId,
            type = TransactionType.EARN,
            source = PointSource.ATTENDANCE,
            amount = Point.ATTENDANCE,
            balanceSnapshot = point.balance,
            description = "출석 체크"
        )
        pointTransactionRepository.save(pointTransaction)

        val zone = ZoneId.of("Asia/Seoul")
        val midnight = LocalDate.now(zone).plusDays(1).atStartOfDay(zone)
        val ttl = Duration.between(ZonedDateTime.now(zone), midnight)
        redisTemplate.opsForValue().set(attendanceKey, "1", ttl)
    }

    @Transactional
    fun earnByAdReward(memberId: Long) {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")
        val point = pointRepository.findByMemberIdWithLock(memberId)
            ?: throw CustomException("포인트 정보가 없습니다.")

        val adRewardKey = AD_REWARD_KEY + memberId
        if (redisTemplate.opsForValue().get(adRewardKey) != null) {
            throw CustomException("광고 보상은 ${Point.AD_REWARD_COOLDOWN_HOURS}시간마다 받을 수 있습니다.")
        }

        point.earn(Point.AD_REWARD)

        val pointTransaction = PointTransaction(
            memberId = memberId,
            type = TransactionType.EARN,
            source = PointSource.AD_REWARD,
            amount = Point.AD_REWARD,
            balanceSnapshot = point.balance,
            description = "광고 보상"
        )
        pointTransactionRepository.save(pointTransaction)

        redisTemplate.opsForValue().set(
            adRewardKey,
            "1",
            Duration.ofHours(Point.AD_REWARD_COOLDOWN_HOURS)
        )
    }

    @Transactional(readOnly = true)
    fun get(memberId: Long): PointGetResponse {
        memberRepository.findByIdOrNull(memberId)
            ?: throw CustomException("존재하지 않는 회원입니다.")
        val point = pointRepository.findByMemberId(memberId)
            ?: throw CustomException("포인트 정보가 없습니다.")

        return PointGetResponse(point.balance)
    }
}