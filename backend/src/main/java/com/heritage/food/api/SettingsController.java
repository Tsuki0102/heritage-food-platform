package com.heritage.food.api;

import com.heritage.food.service.SettingsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/settings")
public class SettingsController {
    
    @Autowired
    private SettingsService settingsService;
    
    @GetMapping
    public Map<String, Object> getSettings() {
        return settingsService.getSettings();
    }
    
    @PutMapping
    public Map<String, Object> saveSettings(@RequestBody Map<String, Object> settings) {
        return settingsService.saveSettings(settings);
    }
}
