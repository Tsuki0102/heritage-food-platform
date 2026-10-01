package com.heritage.food.model;

import lombok.Data;
import java.util.Date;

@Data
public class FoodMedia {
    private Long id;
    private Long foodId;
    private Integer type;
    private String resourcePath;
    private Integer sort;
    private Date uploadTime;
}