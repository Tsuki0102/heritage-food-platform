package com.heritage.food.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.dao.FoodMapper;
import com.heritage.food.dao.UserMapper;
import com.heritage.food.dao.UserRatingMapper;
import com.heritage.food.model.Food;
import com.heritage.food.model.User;
import com.heritage.food.model.UserRating;
import com.heritage.food.service.FoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FoodServiceImpl implements FoodService {

    @Autowired
    private FoodMapper foodMapper;
    @Autowired
    private UserRatingMapper userRatingMapper;
    @Autowired
    private UserMapper userMapper;

    @Override
    public Food getFoodById(Long id) {
        return foodMapper.selectById(id);
    }

    @Override
    public Page<Food> getFoodList(int page, int size, String region, String taste, String heritageLevel, String keyword) {
        Page<Food> foodPage = new Page<>(page, size);
        QueryWrapper<Food> wrapper = new QueryWrapper<>();
        
        if (region != null && !region.isEmpty()) {
            wrapper.eq("region", region);
        }
        
        if (taste != null && !taste.isEmpty()) {
            wrapper.eq("taste", taste);
        }
        
        if (heritageLevel != null && !heritageLevel.isEmpty()) {
            wrapper.eq("heritage_level", heritageLevel);
        }
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like("name", keyword);
        }
        
        return foodMapper.selectPage(foodPage, wrapper);
    }

    @Override
    public Page<Food> getHotFoodList(int page, int size) {
        Page<Food> foodPage = new Page<>(page, size);
        QueryWrapper<Food> wrapper = new QueryWrapper<>();
        wrapper.orderByDesc("view_count");
        return foodMapper.selectPage(foodPage, wrapper);
    }

    @Override
    public List<Food> getFoodByRegion(String region) {
        QueryWrapper<Food> wrapper = new QueryWrapper<>();
        wrapper.eq("region", region);
        return foodMapper.selectList(wrapper);
    }

    @Override
    public List<Food> getFoodByTaste(String taste) {
        QueryWrapper<Food> wrapper = new QueryWrapper<>();
        wrapper.eq("taste", taste);
        return foodMapper.selectList(wrapper);
    }

    @Override
    public void saveFood(Food food) {
        foodMapper.insert(food);
    }

    @Override
    public void updateFood(Food food) {
        foodMapper.updateById(food);
    }

    @Override
    public void deleteFood(Long id) {
        foodMapper.deleteById(id);
    }

    @Override
    public void incrementViewCount(Long id) {
        Food food = foodMapper.selectById(id);
        if (food != null) {
            food.setViewCount(food.getViewCount() + 1);
            foodMapper.updateById(food);
        }
    }

    @Override
    public void incrementCollectionCount(Long id) {
        Food food = foodMapper.selectById(id);
        if (food != null) {
            food.setCollectionCount(food.getCollectionCount() + 1);
            foodMapper.updateById(food);
        }
    }

    @Override
    public List<UserRating> getFoodRatings(Long id) {
        QueryWrapper<UserRating> wrapper = new QueryWrapper<>();
        wrapper.eq("food_id", id);
        List<UserRating> ratings = userRatingMapper.selectList(wrapper);
        
        // 关联查询用户头像
        for (UserRating rating : ratings) {
            User user = userMapper.selectById(rating.getUserId());
            if (user != null) {
                rating.setAvatar(user.getAvatar());
            }
        }
        
        return ratings;
    }

    @Override
    public void saveUserRating(UserRating userRating) {
        userRatingMapper.insert(userRating);
    }
}