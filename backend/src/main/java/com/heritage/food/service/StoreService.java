package com.heritage.food.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Store;

import java.util.List;

public interface StoreService {
    Store getStoreById(Long id);
    Page<Store> getStoreList(int page, int size, String region, String minScore, String keyword);
    List<Store> getAllStores();
    void saveStore(Store store);
    void updateStore(Store store);
    void deleteStore(Long id);
}
