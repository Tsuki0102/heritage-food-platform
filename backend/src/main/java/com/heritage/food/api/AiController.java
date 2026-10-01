package com.heritage.food.api;

import com.heritage.food.service.AiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class AiController {

    @Autowired
    private AiService aiService;

    @GetMapping("/ai/food/explain")
    public String explainFood(@RequestParam String foodName) {
        return aiService.explainFood(foodName);
    }
}
