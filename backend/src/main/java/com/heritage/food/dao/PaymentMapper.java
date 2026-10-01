package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heritage.food.model.Payment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PaymentMapper extends BaseMapper<Payment> {

    Payment selectByOrderId(@Param("orderId") Integer orderId);

    Payment selectByPaymentNo(@Param("paymentNo") String paymentNo);
}
