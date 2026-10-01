package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_review_audit")
public class MerchantReviewAudit {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String userName;

    private String merchantName;

    private String content;

    private String hitWords;

    private LocalDateTime submittedAt;

    private String status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
