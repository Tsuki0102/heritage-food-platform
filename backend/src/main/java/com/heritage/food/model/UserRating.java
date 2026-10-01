package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;

@TableName("tb_user_rating")

@Data
public class UserRating {
    private Long id;
    private Long userId;
    private Long foodId;
    private Integer score;
    private String content;
    private Date createTime;
    
    @TableField(exist = false)
    private String avatar;
}