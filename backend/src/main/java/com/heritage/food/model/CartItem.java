package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;
import java.util.Date;

@Data
@TableName("tb_cart_item")
public class CartItem {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private Long userId;

    private Integer productId;

    private Integer quantity;

    private Date createdAt;

    private Date updatedAt;
    
    @TableField(exist = false)
    private Product product;
}
