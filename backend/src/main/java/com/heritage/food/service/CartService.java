package com.heritage.food.service;

import com.heritage.food.model.CartItem;

import java.util.List;

public interface CartService {

    List<CartItem> getCartList(Long userId);

    CartItem addToCart(Long userId, Integer productId, Integer quantity);

    CartItem updateCartItem(Integer id, Integer quantity);

    void removeFromCart(Integer id);

    void clearCart(Long userId);

    int getCartCount(Long userId);
}
