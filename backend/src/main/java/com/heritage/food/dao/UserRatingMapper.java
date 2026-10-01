package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heritage.food.model.UserRating;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserRatingMapper extends BaseMapper<UserRating> {
}