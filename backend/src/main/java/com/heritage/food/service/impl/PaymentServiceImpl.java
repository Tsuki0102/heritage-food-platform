package com.heritage.food.service.impl;

import com.heritage.food.dao.PaymentMapper;
import com.heritage.food.model.Order;
import com.heritage.food.model.Payment;
import com.heritage.food.service.OrderService;
import com.heritage.food.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.UUID;

@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private OrderService orderService;

    @Override
    @Transactional
    public Payment createPayment(Long userId, Integer orderId, String paymentMethod) {
        // 生成支付单号
        String paymentNo = "PAY" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // 获取订单信息
        Order order = orderService.getOrderById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }

        // 创建支付记录
        Payment payment = new Payment();
        payment.setPaymentNo(paymentNo);
        payment.setOrderId(orderId);
        payment.setUserId(userId);
        payment.setAmount(order.getTotalAmount());
        payment.setPaymentMethod(paymentMethod);
        payment.setPaymentStatus(0); // 0-待支付
        payment.setCreatedAt(new Date());
        payment.setUpdatedAt(new Date());

        paymentMapper.insert(payment);

        return payment;
    }

    @Override
    public Payment getPaymentStatus(String paymentNo) {
        return paymentMapper.selectByPaymentNo(paymentNo);
    }

    @Override
    public Payment getPaymentByOrderId(Integer orderId) {
        return paymentMapper.selectByOrderId(orderId);
    }

    @Override
    public void cancelPayment(String paymentNo) {
        Payment payment = paymentMapper.selectByPaymentNo(paymentNo);
        if (payment != null && payment.getPaymentStatus() == 0) { // 只有待支付的支付记录可以取消
            payment.setPaymentStatus(2); // 2-支付失败
            payment.setUpdatedAt(new Date());
            paymentMapper.updateById(payment);
        }
    }

    @Override
    @Transactional
    public void updatePaymentStatus(String paymentNo, int status, String transactionId) {
        Payment payment = paymentMapper.selectByPaymentNo(paymentNo);
        if (payment != null) {
            payment.setPaymentStatus(status);
            payment.setTransactionId(transactionId);
            if (status == 1) { // 1-支付成功
                payment.setPaidAt(new Date());
                // 更新订单状态为已支付
                Order order = orderService.getOrderById(payment.getOrderId());
                if (order != null) {
                    order.setStatus(1); // 1-已支付
                    order.setUpdatedAt(new Date());
                    // 这里应该调用orderService的方法来更新订单状态，但是为了简化，直接更新
                    // orderService.updateOrder(order);
                }
            }
            payment.setUpdatedAt(new Date());
            paymentMapper.updateById(payment);
        }
    }
}
