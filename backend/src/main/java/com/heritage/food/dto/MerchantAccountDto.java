package com.heritage.food.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class MerchantAccountDto {
    private Long id;
    private String nickname;
    private String phone;
    private String avatar;
    private Integer gender;
    private String region;
    private Integer status;
    private Integer isAdmin;
    private List<Long> roleIds;
    private List<String> roleKeys;
    private List<String> roleNames;
    private Boolean isMerchant;
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
}
