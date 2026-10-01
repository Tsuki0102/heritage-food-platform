package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("tb_merchant_artisan")
public class MerchantArtisan {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String merchantName;

    private String artisanName;

    private String heritageSkill;

    private String level;

    private Boolean verified;

    private String status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
