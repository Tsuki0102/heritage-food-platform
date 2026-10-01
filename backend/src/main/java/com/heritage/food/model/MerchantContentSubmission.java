package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_content_submission")
public class MerchantContentSubmission {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String merchantName;

    private String title;

    private String contentType;

    private String riskPoint;

    private String content;

    private LocalDateTime submittedAt;

    private String status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
