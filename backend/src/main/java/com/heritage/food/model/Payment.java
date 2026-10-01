package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("tb_payment")
public class Payment {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String paymentNo;

    private Integer orderId;

    private Long userId;

    private BigDecimal amount;

    private String paymentMethod;

    private Integer paymentStatus;

    private String transactionId;

    private Date paidAt;

    private Date createdAt;

    private Date updatedAt;
}
