package com.heritage.food.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.dao.StoreActivityMapper;
import com.heritage.food.dao.StoreMapper;
import com.heritage.food.dao.StoreRatingMapper;
import com.heritage.food.dao.StoreSignatureFoodMapper;
import com.heritage.food.dao.UserMapper;
import com.heritage.food.model.Store;
import com.heritage.food.model.StoreActivity;
import com.heritage.food.model.StoreRating;
import com.heritage.food.model.StoreSignatureFood;
import com.heritage.food.model.User;
import com.heritage.food.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StoreServiceImpl implements StoreService {
    
    private static final Map<String, List<String>> PROVINCE_CITIES = new HashMap<>();
    
    static {
        PROVINCE_CITIES.put("河南", Arrays.asList("郑州", "开封", "洛阳", "安阳", "新乡", "焦作", "平顶山", "许昌", "漯河", "三门峡", "南阳", "商丘", "信阳", "周口", "驻马店", "鹤壁", "濮阳"));
        PROVINCE_CITIES.put("广东", Arrays.asList("广州", "深圳", "珠海", "汕头", "佛山", "韶关", "湛江", "肇庆", "江门", "茂名", "惠州", "梅州", "汕尾", "河源", "阳江", "清远", "东莞", "中山", "潮州", "揭阳", "云浮"));
        PROVINCE_CITIES.put("四川", Arrays.asList("成都", "自贡", "攀枝花", "泸州", "德阳", "绵阳", "广元", "遂宁", "内江", "乐山", "南充", "眉山", "宜宾", "广安", "达州", "雅安", "巴中", "资阳"));
        PROVINCE_CITIES.put("浙江", Arrays.asList("杭州", "宁波", "温州", "嘉兴", "湖州", "绍兴", "金华", "衢州", "舟山", "台州", "丽水"));
        PROVINCE_CITIES.put("江苏", Arrays.asList("南京", "无锡", "徐州", "常州", "苏州", "南通", "连云港", "淮安", "盐城", "扬州", "镇江", "泰州", "宿迁"));
        PROVINCE_CITIES.put("陕西", Arrays.asList("西安", "铜川", "宝鸡", "咸阳", "渭南", "延安", "汉中", "榆林", "安康", "商洛"));
    }

    @Autowired
    private StoreMapper storeMapper;
    @Autowired
    private StoreSignatureFoodMapper storeSignatureFoodMapper;
    @Autowired
    private StoreActivityMapper storeActivityMapper;
    @Autowired
    private StoreRatingMapper storeRatingMapper;
    @Autowired
    private UserMapper userMapper;

    @Override
    public Store getStoreById(Long id) {
        Store store = storeMapper.selectById(id);
        if (store != null) {
            // 查询招牌美食
            QueryWrapper<StoreSignatureFood> foodWrapper = new QueryWrapper<>();
            foodWrapper.eq("store_id", id);
            List<StoreSignatureFood> foods = storeSignatureFoodMapper.selectList(foodWrapper);
            store.setFoods(foods);
            
            // 查询店铺活动
            QueryWrapper<StoreActivity> activityWrapper = new QueryWrapper<>();
            activityWrapper.eq("store_id", id);
            List<StoreActivity> activities = storeActivityMapper.selectList(activityWrapper);
            store.setActivities(activities);
            
            // 查询店铺评价
            QueryWrapper<StoreRating> ratingWrapper = new QueryWrapper<>();
            ratingWrapper.eq("store_id", id);
            List<StoreRating> ratings = storeRatingMapper.selectList(ratingWrapper);
            
            // 关联查询用户信息
            for (StoreRating rating : ratings) {
                User user = userMapper.selectById(rating.getUserId());
                if (user != null) {
                    rating.setAvatar(user.getAvatar());
                    rating.setNickname(user.getNickname());
                }
            }
            
            store.setComments(ratings);
        }
        return store;
    }

    @Override
    public Page<Store> getStoreList(int page, int size, String region, String minScore, String keyword) {
        Page<Store> storePage = new Page<>(page, size);
        QueryWrapper<Store> wrapper = new QueryWrapper<>();
        
        if (region != null && !region.isEmpty()) {
            wrapper.and(w -> {
                w.like("address", region);
                if (PROVINCE_CITIES.containsKey(region)) {
                    for (String city : PROVINCE_CITIES.get(region)) {
                        w.or().like("address", city);
                    }
                }
            });
        }
        
        if (minScore != null && !minScore.isEmpty()) {
            wrapper.ge("score", Double.parseDouble(minScore));
        }
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like("name", keyword);
        }
        
        wrapper.orderByDesc("score");
        return storeMapper.selectPage(storePage, wrapper);
    }

    @Override
    public List<Store> getAllStores() {
        return storeMapper.selectList(null);
    }

    @Override
    public void saveStore(Store store) {
        storeMapper.insert(store);
    }

    @Override
    public void updateStore(Store store) {
        storeMapper.updateById(store);
    }

    @Override
    public void deleteStore(Long id) {
        storeMapper.deleteById(id);
    }
}
