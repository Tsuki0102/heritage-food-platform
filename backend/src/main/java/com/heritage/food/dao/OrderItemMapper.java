package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heritage.food.model.OrderItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {

    List<OrderItem> selectByOrderId(@Param("orderId") Integer orderId);

    void batchInsert(@Param("items") List<OrderItem> items);
}
