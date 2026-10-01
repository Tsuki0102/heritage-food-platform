package com.heritage.food.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Order;
import com.heritage.food.model.OrderItem;

import java.util.List;
import java.util.Map;

public interface OrderService {

    Order createOrder(Long userId, Map<String, Object> orderData, List<OrderItem> items);

    Page<Order> getOrderList(int page, int pageSize, Long userId, Integer status);

    Order getOrderById(Integer id);

    Order getOrderByNo(String orderNo);

    void cancelOrder(Integer id);

    void confirmReceive(Integer id);

    List<Order> getRecentOrders(Long userId, int limit);
}
