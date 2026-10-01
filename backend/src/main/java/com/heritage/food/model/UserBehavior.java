package com.heritage.food.model;

import lombok.Data;
import java.util.Date;

@Data
public class UserBehavior {
    private Long id;
    private Long userId;
    private Integer behaviorType;
    private Long objectId;
    private Date behaviorTime;
}