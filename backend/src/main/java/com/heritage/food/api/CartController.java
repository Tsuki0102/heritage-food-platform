package com.heritage.food.api;

import com.heritage.food.model.CartItem;
import com.heritage.food.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping
    public Map<String, Object> getCartList(@RequestParam Long userId) {
        List<CartItem> cartItems = cartService.getCartList(userId);
        Map<String, Object> result = new HashMap<>();
        result.put("records", cartItems);
        result.put("total", cartItems.size());
        return result;
    }

    @PostMapping
    public CartItem addToCart(@RequestParam Long userId, @RequestBody Map<String, Object> data) {
        Integer productId = (Integer) data.get("productId");
        Integer quantity = (Integer) data.get("quantity");
        return cartService.addToCart(userId, productId, quantity);
    }

    @PutMapping("/{id}")
    public CartItem updateCartItem(@PathVariable Integer id, @RequestBody Map<String, Object> data) {
        Integer quantity = (Integer) data.get("quantity");
        return cartService.updateCartItem(id, quantity);
    }

    @DeleteMapping("/{id}")
    public void removeFromCart(@PathVariable Integer id) {
        cartService.removeFromCart(id);
    }

    @DeleteMapping("/clear")
    public void clearCart(@RequestParam Long userId) {
        cartService.clearCart(userId);
    }

    @GetMapping("/count")
    public Map<String, Object> getCartCount(@RequestParam Long userId) {
        int count = cartService.getCartCount(userId);
        Map<String, Object> result = new HashMap<>();
        result.put("count", count);
        return result;
    }
}