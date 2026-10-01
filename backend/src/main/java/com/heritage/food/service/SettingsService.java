package com.heritage.food.service;

import com.heritage.food.model.Settings;
import java.util.Map;

public interface SettingsService {
    Map<String, Object> getSettings();
    Map<String, Object> saveSettings(Map<String, Object> settings);
    Settings getSettingByKey(String key);
    void saveSetting(Settings setting);
    void updateSetting(Settings setting);
    void deleteSetting(Long id);
}
