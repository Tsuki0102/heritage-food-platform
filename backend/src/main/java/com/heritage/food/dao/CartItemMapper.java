package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heritage.food.model.CartItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CartItemMapper extends BaseMapper<CartItem> {

    List<CartItem> selectByUserId(@Param("userId") Long userId);

    CartItem selectByUserIdAndProductId(@Param("userId") Long userId, @Param("productId") Integer productId);

    int countByUserId(@Param("userId") Long userId);

    int deleteByUserId(@Param("userId") Long userId);
}
