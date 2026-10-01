package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heritage.food.model.Settings;
import org.apache.ibatis.annotations.Select;
import java.util.List;

public interface SettingsMapper extends BaseMapper<Settings> {
    
    @Select("SELECT * FROM tb_settings WHERE status = 1 ORDER BY id")
    List<Settings> selectAllActiveSettings();
    
    @Select("SELECT * FROM tb_settings WHERE `key` = #{key} AND status = 1")
    Settings selectByKey(String key);
}
