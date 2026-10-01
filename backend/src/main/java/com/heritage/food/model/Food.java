package com.heritage.food.model;

import lombok.Data;
import java.util.Date;
import java.math.BigDecimal;
import com.baomidou.mybatisplus.annotation.TableName;

@Data
@TableName("tb_food")
public class Food {
    private Long id;
    private String name;
    private String region;
    private String taste;
    private String heritageLevel;
    private String history;
    private String ingredients;
    private String process;
    private String coverImage;
    private BigDecimal averageScore;
    private Integer collectionCount;
    private Integer viewCount;
    private Date createTime;
    private Date updateTime;
}