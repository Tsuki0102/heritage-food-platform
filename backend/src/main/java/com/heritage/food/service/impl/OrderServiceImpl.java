package com.heritage.food.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.dao.OrderMapper;
import com.heritage.food.dao.OrderItemMapper;
import com.heritage.food.model.Order;
import com.heritage.food.model.OrderItem;
import com.heritage.food.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private OrderItemMapper orderItemMapper;

    @Override
    @Transactional
    public Order createOrder(Long userId, Map<String, Object> orderData, List<OrderItem> items) {
        // 生成订单号
        String orderNo = "ORD" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // 计算总金额
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderItem item : items) {
            // 如果subtotal为null，根据price和quantity计算
            if (item.getSubtotal() == null && item.getPrice() != null) {
                item.setSubtotal(item.getPrice().multiply(new BigDecimal(item.getQuantity())));
            }
            if (item.getSubtotal() != null) {
                totalAmount = totalAmount.add(item.getSubtotal());
            }
        }

        // 创建订单
        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setStatus(0); // 0-待支付
        order.setReceiverName((String) orderData.get("receiverName"));
        order.setReceiverPhone((String) orderData.get("receiverPhone"));
        order.setReceiverAddress((String) orderData.get("receiverAddress"));
        order.setRemark((String) orderData.get("remark"));
        order.setCreatedAt(new Date());
        order.setUpdatedAt(new Date());

        orderMapper.insert(order);

        // 保存订单商品
        for (OrderItem item : items) {
            item.setOrderId(order.getId());
            item.setCreatedAt(new Date());
        }
        orderItemMapper.batchInsert(items);

        return order;
    }

    @Override
    public Page<Order> getOrderList(int page, int pageSize, Long userId, Integer status) {
        Page<Order> pageInfo = new Page<>(page, pageSize);
        return orderMapper.selectOrderList(pageInfo, userId, status);
    }

    @Override
    public Order getOrderById(Integer id) {
        return orderMapper.selectById(id);
    }

    @Override
    public Order getOrderByNo(String orderNo) {
        return orderMapper.selectOrderByNo(orderNo);
    }

    @Override
    public void cancelOrder(Integer id) {
        Order order = orderMapper.selectById(id);
        if (order != null && order.getStatus() == 0) { // 只有待支付的订单可以取消
            order.setStatus(4); // 4-已取消
            order.setUpdatedAt(new Date());
            orderMapper.updateById(order);
        }
    }

    @Override
    public void confirmReceive(Integer id) {
        Order order = orderMapper.selectById(id);
        if (order != null && order.getStatus() == 2) { // 只有已发货的订单可以确认收货
            order.setStatus(3); // 3-已完成
            order.setUpdatedAt(new Date());
            orderMapper.updateById(order);
        }
    }

    @Override
    public List<Order> getRecentOrders(Long userId, int limit) {
        return orderMapper.selectRecentOrders(userId, limit);
    }
}
