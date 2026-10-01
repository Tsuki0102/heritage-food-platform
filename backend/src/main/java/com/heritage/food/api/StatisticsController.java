package com.heritage.food.api;

import com.heritage.food.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/statistics")
public class StatisticsController {

    @Autowired
    private StatisticsService statisticsService;

    @GetMapping("/overview")
    public Map<String, Object> getOverview(@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate) {
        return statisticsService.getOverview(startDate, endDate);
    }

    @GetMapping("/user-trend")
    public List<Map<String, Object>> getUserTrend(@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate) {
        return statisticsService.getUserTrend(startDate, endDate);
    }

    @GetMapping("/food-category")
    public List<Map<String, Object>> getFoodCategory() {
        return statisticsService.getFoodCategory();
    }

    @GetMapping("/user-region")
    public List<Map<String, Object>> getUserRegion() {
        return statisticsService.getUserRegion();
    }

    @GetMapping("/activity")
    public List<Map<String, Object>> getActivityData() {
        return statisticsService.getActivityData();
    }

    @GetMapping("/top-foods")
    public List<Map<String, Object>> getTopFoods() {
        return statisticsService.getTopFoods();
    }

    @GetMapping("/export")
    public byte[] exportData(@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate) {
        return statisticsService.exportData(startDate, endDate);
    }
}
