package com.heritage.food.model;

import lombok.Data;
import java.util.Date;

@Data
public class Settings {
    private Long id;
    private String key;
    private String value;
    private String description;
    private Integer status;
    private Date createTime;
    private Date updateTime;
}
