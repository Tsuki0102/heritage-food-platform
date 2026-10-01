package com.heritage.food.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Product;

import java.util.List;

public interface ProductService {

    Page<Product> getProductList(int page, int pageSize, String category, String keyword, String sortBy, String sortOrder);

    Product getProductById(Integer id);

    List<String> getProductCategories();

    List<Product> getHotProducts(int limit);

    List<Product> getRecommendProducts(int limit);

    void saveProduct(Product product);

    void updateProduct(Product product);

    void deleteProduct(Integer id);
}
