package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;

@TableName("tb_store_activity")

@Data
public class StoreActivity {
    private Long id;
    private Long storeId;
    private String activityType;
    private String activityRule;
    private Date startTime;
    private Date endTime;
    private Integer status;
    private Date createTime;
}