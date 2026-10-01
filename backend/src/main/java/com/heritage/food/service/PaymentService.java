package com.heritage.food.service;

import com.heritage.food.model.Payment;

import java.util.Map;

public interface PaymentService {

    Payment createPayment(Long userId, Integer orderId, String paymentMethod);

    Payment getPaymentStatus(String paymentNo);

    Payment getPaymentByOrderId(Integer orderId);

    void cancelPayment(String paymentNo);

    void updatePaymentStatus(String paymentNo, int status, String transactionId);
}
