package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Order;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {

    Page<Order> selectOrderList(Page<Order> page, 
                               @Param("userId") Long userId, 
                               @Param("status") Integer status);

    Order selectOrderByNo(@Param("orderNo") String orderNo);

    List<Order> selectRecentOrders(@Param("userId") Long userId, @Param("limit") int limit);
}
