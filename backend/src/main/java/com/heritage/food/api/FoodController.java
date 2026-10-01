package com.heritage.food.api;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Food;
import com.heritage.food.model.UserRating;
import com.heritage.food.service.FoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/food")
public class FoodController {

    @Autowired
    private FoodService foodService;

    @GetMapping("/{id}")
    public Food getFoodById(@PathVariable Long id) {
        foodService.incrementViewCount(id);
        return foodService.getFoodById(id);
    }

    @GetMapping("/list")
    public Page<Food> getFoodList(
            @RequestParam int page, 
            @RequestParam int size,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) String taste,
            @RequestParam(required = false) String heritage_level,
            @RequestParam(required = false) String keyword) {
        return foodService.getFoodList(page, size, region, taste, heritage_level, keyword);
    }

    @GetMapping("/hot/list")
    public Page<Food> getHotFoodList(@RequestParam int page, @RequestParam int size) {
        return foodService.getHotFoodList(page, size);
    }

    @GetMapping("/region/{region}")
    public List<Food> getFoodByRegion(@PathVariable String region) {
        return foodService.getFoodByRegion(region);
    }

    @GetMapping("/taste/{taste}")
    public List<Food> getFoodByTaste(@PathVariable String taste) {
        return foodService.getFoodByTaste(taste);
    }

    @PostMapping
    public void saveFood(@RequestBody Food food) {
        foodService.saveFood(food);
    }

    @PutMapping
    public void updateFood(@RequestBody Food food) {
        foodService.updateFood(food);
    }

    @DeleteMapping("/{id}")
    public void deleteFood(@PathVariable Long id) {
        foodService.deleteFood(id);
    }

    @GetMapping("/{id}/ratings")
    public List<UserRating> getFoodRatings(@PathVariable Long id) {
        return foodService.getFoodRatings(id);
    }

    @PostMapping("/rating/{foodId}")
public void submitFoodRating(
    @PathVariable Long foodId,  // 接收路径 ID
    @RequestBody UserRating userRating
) {
    
    userRating.setFoodId(foodId); 
    foodService.saveUserRating(userRating);
}
}