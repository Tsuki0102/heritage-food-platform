package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_profile")
public class MerchantProfile {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String storeName;

    private String storeStatus;

    private BigDecimal commissionRate;

    private Boolean heritageCertified;

    private BigDecimal settlementAmount;

    private BigDecimal withdrawPending;

    private LocalDateTime lastSettlementAt;

    private String contactName;

    private String contactPhone;

    private String introduction;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
