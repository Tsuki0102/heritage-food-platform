package com.heritage.food.service.impl;

import com.heritage.food.dao.SettingsMapper;
import com.heritage.food.model.Settings;
import com.heritage.food.service.SettingsService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SettingsServiceImpl implements SettingsService {
    
    @Autowired
    private SettingsMapper settingsMapper;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    @Override
    public Map<String, Object> getSettings() {
        Map<String, Object> result = new HashMap<>();
        try {
            // 从数据库获取所有配置
            List<Settings> settingsList = settingsMapper.selectAllActiveSettings();
            
            // 构建返回数据结构
            Map<String, Object> basic = new HashMap<>();
            Map<String, Object> features = new HashMap<>();
            Map<String, Object> security = new HashMap<>();
            Map<String, Object> storage = new HashMap<>();
            
            // 遍历配置，按类型分类
            for (Settings setting : settingsList) {
                String key = setting.getKey();
                String value = setting.getValue();
                
                // 根据key的前缀将配置分类
                if (key.startsWith("basic.")) {
                    basic.put(key.substring(6), value);
                } else if (key.startsWith("features.")) {
                    features.put(key.substring(9), Boolean.parseBoolean(value));
                } else if (key.startsWith("security.")) {
                    if (key.equals("security.loginTimeout")) {
                        security.put(key.substring(9), Integer.parseInt(value));
                    } else if (key.equals("security.ipRestriction") || key.equals("security.captcha")) {
                        security.put(key.substring(9), Boolean.parseBoolean(value));
                    } else {
                        security.put(key.substring(9), value);
                    }
                } else if (key.startsWith("storage.")) {
                    if (key.equals("storage.fileSizeLimit")) {
                        storage.put(key.substring(8), Integer.parseInt(value));
                    } else {
                        storage.put(key.substring(8), value);
                    }
                }
            }
            
            // 如果数据库中没有配置，使用默认值
            if (basic.isEmpty()) {
                basic.put("siteName", "heritage-food-frontend");
                basic.put("siteDomain", "http://localhost:3000");
                basic.put("siteDescription", "美食传承与分享平台");
                basic.put("siteKeywords", "美食,传承,文化,分享");
                basic.put("contactEmail", "contact@example.com");
                basic.put("contactPhone", "13800138000");
                basic.put("icpNumber", "京ICP备12345678号");
                basic.put("copyright", "© 2026 heritage-food-frontend. All rights reserved.");
            }
            
            if (features.isEmpty()) {
                features.put("userRegistration", true);
                features.put("userLogin", true);
                features.put("communityPosting", true);
                features.put("commentFunction", true);
                features.put("collectionFunction", true);
                features.put("searchFunction", true);
                features.put("mapFunction", true);
                features.put("tasteTest", true);
            }
            
            if (security.isEmpty()) {
                security.put("apiKey", "test-api-key");
                security.put("jwtSecret", "test-jwt-secret");
                security.put("loginTimeout", 30);
                security.put("passwordComplexity", "medium");
                security.put("ipRestriction", false);
                security.put("captcha", true);
            }
            
            if (storage.isEmpty()) {
                storage.put("storageType", "local");
                storage.put("localPath", "./uploads");
                storage.put("cloudService", "aliyun");
                storage.put("accessKey", "");
                storage.put("secretKey", "");
                storage.put("bucketName", "");
                storage.put("fileSizeLimit", 10);
            }
            
            result.put("basic", basic);
            result.put("features", features);
            result.put("security", security);
            result.put("storage", storage);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取系统设置失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @Override
    public Map<String, Object> saveSettings(Map<String, Object> settings) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 从传入的settings中提取各个部分
            Map<String, Object> basic = (Map<String, Object>) settings.get("basic");
            Map<String, Object> features = (Map<String, Object>) settings.get("features");
            Map<String, Object> security = (Map<String, Object>) settings.get("security");
            Map<String, Object> storage = (Map<String, Object>) settings.get("storage");
            
            // 保存basic配置
            if (basic != null) {
                for (Map.Entry<String, Object> entry : basic.entrySet()) {
                    saveOrUpdateSetting("basic." + entry.getKey(), entry.getValue().toString());
                }
            }
            
            // 保存features配置
            if (features != null) {
                for (Map.Entry<String, Object> entry : features.entrySet()) {
                    saveOrUpdateSetting("features." + entry.getKey(), entry.getValue().toString());
                }
            }
            
            // 保存security配置
            if (security != null) {
                for (Map.Entry<String, Object> entry : security.entrySet()) {
                    saveOrUpdateSetting("security." + entry.getKey(), entry.getValue().toString());
                }
            }
            
            // 保存storage配置
            if (storage != null) {
                for (Map.Entry<String, Object> entry : storage.entrySet()) {
                    saveOrUpdateSetting("storage." + entry.getKey(), entry.getValue().toString());
                }
            }
            
            result.put("success", true);
            result.put("message", "系统设置保存成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "保存系统设置失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    private void saveOrUpdateSetting(String key, String value) {
        Settings existingSetting = settingsMapper.selectByKey(key);
        if (existingSetting != null) {
            // 更新现有配置
            existingSetting.setValue(value);
            settingsMapper.updateById(existingSetting);
        } else {
            // 创建新配置
            Settings newSetting = new Settings();
            newSetting.setKey(key);
            newSetting.setValue(value);
            newSetting.setStatus(1);
            settingsMapper.insert(newSetting);
        }
    }
    
    @Override
    public Settings getSettingByKey(String key) {
        return settingsMapper.selectByKey(key);
    }
    
    @Override
    public void saveSetting(Settings setting) {
        settingsMapper.insert(setting);
    }
    
    @Override
    public void updateSetting(Settings setting) {
        settingsMapper.updateById(setting);
    }
    
    @Override
    public void deleteSetting(Long id) {
        settingsMapper.deleteById(id);
    }
}
