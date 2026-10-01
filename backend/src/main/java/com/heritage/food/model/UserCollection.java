package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;

@Data
@TableName("tb_user_collection")
public class UserCollection {
    private Long id;
    private Long userId;
    private Integer collectionType;
    private Long objectId;
    private Date collectionTime;
}