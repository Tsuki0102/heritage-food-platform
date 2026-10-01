package com.heritage.food.model;

import lombok.Data;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;

@Data
@TableName("tb_store_rating")
public class StoreRating {
    private Long id;
    private Long storeId;
    private Long userId;
    private Integer score;
    private String content;
    private String images;
    private Date createTime;
    
    @TableField(exist = false)
    private String avatar;
    @TableField(exist = false)
    private String nickname;
}
