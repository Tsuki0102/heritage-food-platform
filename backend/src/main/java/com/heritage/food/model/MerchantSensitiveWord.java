package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_sensitive_word")
public class MerchantSensitiveWord {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String word;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
