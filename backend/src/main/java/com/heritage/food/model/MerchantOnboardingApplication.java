package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_onboarding_application")
public class MerchantOnboardingApplication {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String applicantName;

    private String phone;

    private String storeName;

    private String category;

    private String region;

    private LocalDateTime submittedAt;

    private String note;

    private String attachmentUrls;

    private String status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
