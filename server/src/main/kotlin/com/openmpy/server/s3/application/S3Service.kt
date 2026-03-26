package com.openmpy.server.s3.application

import com.openmpy.server.common.properties.S3Properties
import com.openmpy.server.s3.dto.response.PresignedUrlResponse
import org.springframework.stereotype.Service
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.presigner.S3Presigner
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest
import java.time.Duration

private const val PRESIGNED_URL_EXPIRE_MINUTES: Long = 5

@Service
class S3Service(

    private val s3Properties: S3Properties,
    private val s3Client: S3Client,
    private val s3Presigner: S3Presigner
) {

    fun createPresignedUrl(key: String): PresignedUrlResponse {
        val presignRequest = PutObjectPresignRequest.builder()
            .signatureDuration(Duration.ofMinutes(PRESIGNED_URL_EXPIRE_MINUTES))
            .putObjectRequest {
                it.bucket(s3Properties.bucket)
                    .key(key)
                    .contentType("image/jpeg")
            }
            .build()

        val url = s3Presigner.presignPutObject(presignRequest).url().toString()
        return PresignedUrlResponse(url, key)
    }
}