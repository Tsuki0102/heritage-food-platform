package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("tb_product")
public class Product {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String name;

    private String description;

    private BigDecimal price;

    private BigDecimal originalPrice;

    private String coverImage;

    private String images;

    private String category;

    private Integer stock;

    private Integer salesCount;

    private BigDecimal rating;

    private Integer status;

    private Date createdAt;

    private Date updatedAt;
}
