package com.openmpy.server.member.application

import com.openmpy.server.common.exception.CustomException
import com.openmpy.server.member.domain.entity.MemberPrivatePhoto
import com.openmpy.server.member.repository.MemberPrivatePhotoRepository
import com.openmpy.server.member.repository.MemberRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class MemberPrivatePhotoService(

    private val memberPrivatePhotoRepository: MemberPrivatePhotoRepository,
    private val memberRepository: MemberRepository,
) {

    @Transactional
    fun open(ownerId: Long, targetId: Long) {
        if (ownerId == targetId) throw CustomException("자기 자신에게 비밀 사진을 공개할 수 없습니다.")

        val owner = (memberRepository.findByIdOrNull(ownerId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val target = (memberRepository.findByIdOrNull(targetId)
            ?: throw CustomException("존재하지 않는 회원입니다."))

        if (memberPrivatePhotoRepository.existsByOwnerAndTarget(owner, target)) {
            throw CustomException("이미 비밀 사진을 공개한 회원입니다.")
        }

        val privatePhoto = MemberPrivatePhoto(
            owner = owner,
            target = target
        )
        memberPrivatePhotoRepository.save(privatePhoto)
    }

    @Transactional
    fun close(ownerId: Long, targetId: Long) {
        val owner = (memberRepository.findByIdOrNull(ownerId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val target = (memberRepository.findByIdOrNull(targetId)
            ?: throw CustomException("존재하지 않는 회원입니다."))
        val privatePhoto = memberPrivatePhotoRepository.findByOwnerAndTarget(owner, target)
            ?: throw CustomException("비밀 사진 공개 내역이 존재하지 않습니다.")

        memberPrivatePhotoRepository.delete(privatePhoto)
    }
}