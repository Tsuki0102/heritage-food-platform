package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heritage.food.model.Food;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FoodMapper extends BaseMapper<Food> {
}