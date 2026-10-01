package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_settlement")
public class MerchantSettlement {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String merchantName;

    private String period;

    private Integer orderCount;

    private BigDecimal turnover;

    private BigDecimal commissionAmount;

    private BigDecimal payableAmount;

    private String status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
