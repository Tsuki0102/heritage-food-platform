package com.heritage.food.api;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Store;
import com.heritage.food.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/store")
public class StoreController {

    @Autowired
    private StoreService storeService;

    @GetMapping("/{id}")
    public Store getStoreById(@PathVariable Long id) {
        return storeService.getStoreById(id);
    }

    @GetMapping("/list")
    public Page<Store> getStoreList(
            @RequestParam int page, 
            @RequestParam int size,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) String minScore,
            @RequestParam(required = false) String keyword) {
        return storeService.getStoreList(page, size, region, minScore, keyword);
    }

    @GetMapping("/all")
    public List<Store> getAllStores() {
        return storeService.getAllStores();
    }

    @PostMapping
    public void saveStore(@RequestBody Store store) {
        storeService.saveStore(store);
    }

    @PutMapping
    public void updateStore(@RequestBody Store store) {
        storeService.updateStore(store);
    }

    @DeleteMapping("/{id}")
    public void deleteStore(@PathVariable Long id) {
        storeService.deleteStore(id);
    }
}
