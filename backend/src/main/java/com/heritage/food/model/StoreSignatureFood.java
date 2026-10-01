package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;

@Data
@TableName("tb_store_signature_food")
public class StoreSignatureFood {

    private Long id;
    private Long storeId;
    private String name;
    private String description;
    private BigDecimal price;
    private String image;
}