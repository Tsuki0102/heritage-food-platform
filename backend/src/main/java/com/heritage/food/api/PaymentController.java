package com.heritage.food.api;

import com.heritage.food.model.Payment;
import com.heritage.food.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @PostMapping
    public Map<String, Object> createPayment(@RequestParam Long userId, @RequestBody Map<String, Object> data) {
        Integer orderId = (Integer) data.get("orderId");
        String paymentMethod = (String) data.get("paymentMethod");

        Payment payment = paymentService.createPayment(userId, orderId, paymentMethod);
        Map<String, Object> result = new java.util.HashMap<>();
        result.put("paymentNo", payment.getPaymentNo());
        // 这里可以根据支付方式生成不同的支付链接或二维码
        if ("alipay".equals(paymentMethod)) {
            result.put("payUrl", "https://example.com/pay/alipay?no=" + payment.getPaymentNo());
        } else if ("wechat".equals(paymentMethod)) {
            result.put("qrCode", "https://example.com/qrcode?no=" + payment.getPaymentNo());
        }
        return result;
    }

    @GetMapping("/{paymentNo}")
    public Payment getPaymentStatus(@PathVariable String paymentNo) {
        return paymentService.getPaymentStatus(paymentNo);
    }

    @GetMapping("/order/{orderId}")
    public Payment getPaymentByOrderId(@PathVariable Integer orderId) {
        return paymentService.getPaymentByOrderId(orderId);
    }

    @DeleteMapping("/{paymentNo}")
    public void cancelPayment(@PathVariable String paymentNo) {
        paymentService.cancelPayment(paymentNo);
    }
}