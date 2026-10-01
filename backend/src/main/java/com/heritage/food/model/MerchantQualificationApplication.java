package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_qualification_application")
public class MerchantQualificationApplication {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String merchantName;

    private String projectName;

    private String certificateNo;

    private String issuer;

    private LocalDateTime submittedAt;

    private String note;

    private String attachmentUrls;

    private String status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
