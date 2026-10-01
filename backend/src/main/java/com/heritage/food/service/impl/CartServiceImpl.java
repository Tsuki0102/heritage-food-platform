package com.heritage.food.service.impl;

import com.heritage.food.dao.CartItemMapper;
import com.heritage.food.dao.ProductMapper;
import com.heritage.food.model.CartItem;
import com.heritage.food.model.Product;
import com.heritage.food.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartItemMapper cartItemMapper;
    
    @Autowired
    private ProductMapper productMapper;

    @Override
    public List<CartItem> getCartList(Long userId) {
        List<CartItem> cartItems = cartItemMapper.selectByUserId(userId);
        // 为每个购物车项关联查询商品信息
        for (CartItem item : cartItems) {
            Product product = productMapper.selectById(item.getProductId());
            if (product != null) {
                item.setProduct(product);
            }
        }
        return cartItems;
    }

    @Override
    public CartItem addToCart(Long userId, Integer productId, Integer quantity) {
        // 检查是否已存在
        CartItem existingItem = cartItemMapper.selectByUserIdAndProductId(userId, productId);
        if (existingItem != null) {
            // 存在则更新数量
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
            cartItemMapper.updateById(existingItem);
            // 关联商品信息
            Product product = productMapper.selectById(existingItem.getProductId());
            if (product != null) {
                existingItem.setProduct(product);
            }
            return existingItem;
        } else {
            // 不存在则创建新记录
            CartItem newItem = new CartItem();
            newItem.setUserId(userId);
            newItem.setProductId(productId);
            newItem.setQuantity(quantity);
            cartItemMapper.insert(newItem);
            // 关联商品信息
            Product product = productMapper.selectById(productId);
            if (product != null) {
                newItem.setProduct(product);
            }
            return newItem;
        }
    }

    @Override
    public CartItem updateCartItem(Integer id, Integer quantity) {
        CartItem cartItem = cartItemMapper.selectById(id);
        if (cartItem != null) {
            cartItem.setQuantity(quantity);
            cartItemMapper.updateById(cartItem);
            // 关联商品信息
            Product product = productMapper.selectById(cartItem.getProductId());
            if (product != null) {
                cartItem.setProduct(product);
            }
        }
        return cartItem;
    }

    @Override
    public void removeFromCart(Integer id) {
        cartItemMapper.deleteById(id);
    }

    @Override
    public void clearCart(Long userId) {
        cartItemMapper.deleteByUserId(userId);
    }

    @Override
    public int getCartCount(Long userId) {
        return cartItemMapper.countByUserId(userId);
    }
}
