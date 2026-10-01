package com.heritage.food.api;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Order;
import com.heritage.food.model.OrderItem;
import com.heritage.food.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @PostMapping
    public Order createOrder(@RequestParam Long userId, @RequestBody Map<String, Object> data) {
        // 手动将LinkedHashMap转换为OrderItem对象
        List<OrderItem> items = new java.util.ArrayList<>();
        @SuppressWarnings("unchecked")
        List<java.util.Map<String, Object>> itemMaps = (List<java.util.Map<String, Object>>) data.get("items");
        if (itemMaps != null) {
            for (java.util.Map<String, Object> map : itemMaps) {
                OrderItem item = new OrderItem();
                item.setProductId((Integer) map.get("productId"));
                item.setProductName((String) map.get("name"));
                item.setCoverImage((String) map.get("coverImage"));
                // 处理价格字段，支持不同类型
                Object priceObj = map.get("price");
                if (priceObj != null) {
                    if (priceObj instanceof Double) {
                        item.setPrice(java.math.BigDecimal.valueOf((Double) priceObj));
                    } else if (priceObj instanceof Integer) {
                        item.setPrice(java.math.BigDecimal.valueOf((Integer) priceObj));
                    } else if (priceObj instanceof String) {
                        try {
                            item.setPrice(new java.math.BigDecimal((String) priceObj));
                        } catch (Exception e) {
                            // 价格转换失败，设置默认值
                            item.setPrice(java.math.BigDecimal.ZERO);
                        }
                    } else {
                        // 其他类型，设置默认值
                        item.setPrice(java.math.BigDecimal.ZERO);
                    }
                } else {
                    // 价格为null，设置默认值
                    item.setPrice(java.math.BigDecimal.ZERO);
                }
                item.setQuantity((Integer) map.get("quantity"));
                items.add(item);
            }
        }
        return orderService.createOrder(userId, data, items);
    }

    @GetMapping("/list")
    public Map<String, Object> getOrderList(@RequestParam Long userId, @RequestParam int page, 
                                           @RequestParam int pageSize, 
                                           @RequestParam(required = false) Integer status) {
        Page<Order> orderPage = orderService.getOrderList(page, pageSize, userId, status);
        Map<String, Object> result = new java.util.HashMap<>();
        result.put("records", orderPage.getRecords());
        result.put("total", orderPage.getTotal());
        result.put("page", page);
        result.put("pageSize", pageSize);
        result.put("totalPages", orderPage.getPages());
        return result;
    }

    @GetMapping("/{id}")
    public Order getOrderById(@PathVariable Integer id) {
        return orderService.getOrderById(id);
    }

    @GetMapping("/no/{orderNo}")
    public Order getOrderByNo(@PathVariable String orderNo) {
        return orderService.getOrderByNo(orderNo);
    }

    @PutMapping("/{id}/cancel")
    public void cancelOrder(@PathVariable Integer id) {
        orderService.cancelOrder(id);
    }

    @PutMapping("/{id}/receive")
    public void confirmReceive(@PathVariable Integer id) {
        orderService.confirmReceive(id);
    }
}