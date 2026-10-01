package com.heritage.food.service;

import java.util.List;
import java.util.Map;

public interface StatisticsService {
    Map<String, Object> getOverview(String startDate, String endDate);
    List<Map<String, Object>> getUserTrend(String startDate, String endDate);
    List<Map<String, Object>> getFoodCategory();
    List<Map<String, Object>> getUserRegion();
    List<Map<String, Object>> getActivityData();
    List<Map<String, Object>> getTopFoods();
    byte[] exportData(String startDate, String endDate);
}
