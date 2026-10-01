package com.heritage.food.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Food;
import com.heritage.food.model.UserRating;

import java.util.List;

public interface FoodService {
    Food getFoodById(Long id);
    Page<Food> getFoodList(int page, int size, String region, String taste, String heritageLevel, String keyword);
    Page<Food> getHotFoodList(int page, int size);
    List<Food> getFoodByRegion(String region);
    List<Food> getFoodByTaste(String taste);
    void saveFood(Food food);
    void updateFood(Food food);
    void deleteFood(Long id);
    void incrementViewCount(Long id);
    void incrementCollectionCount(Long id);
    List<UserRating> getFoodRatings(Long id);
    void saveUserRating(UserRating userRating);
}