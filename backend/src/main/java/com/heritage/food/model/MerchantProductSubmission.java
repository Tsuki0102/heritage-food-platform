package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_product_submission")
public class MerchantProductSubmission {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String merchantName;

    private String productName;

    private String category;

    private BigDecimal price;

    private String heritageTag;

    private String description;

    private LocalDateTime submittedAt;

    private String status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
