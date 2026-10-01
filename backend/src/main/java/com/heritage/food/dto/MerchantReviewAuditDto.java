package com.heritage.food.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class MerchantReviewAuditDto {
    private Long id;
    private String userName;
    private String merchantName;
    private String content;
    private List<String> hitWords;
    private LocalDateTime submittedAt;
    private String status;
}
