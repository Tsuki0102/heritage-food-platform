package com.heritage.food.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.dao.ProductMapper;
import com.heritage.food.model.Product;
import com.heritage.food.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Override
    public Page<Product> getProductList(int page, int pageSize, String category, String keyword, String sortBy, String sortOrder) {
        Page<Product> pageInfo = new Page<>(page, pageSize);
        return productMapper.selectProductList(pageInfo, category, keyword, sortBy, sortOrder);
    }

    @Override
    public Product getProductById(Integer id) {
        return productMapper.selectById(id);
    }

    @Override
    public List<String> getProductCategories() {
        return productMapper.selectAllCategories();
    }

    @Override
    public List<Product> getHotProducts(int limit) {
        return productMapper.selectHotProducts(limit);
    }

    @Override
    public List<Product> getRecommendProducts(int limit) {
        return productMapper.selectRecommendProducts(limit);
    }

    @Override
    public void saveProduct(Product product) {
        productMapper.insert(product);
    }

    @Override
    public void updateProduct(Product product) {
        productMapper.updateById(product);
    }

    @Override
    public void deleteProduct(Integer id) {
        productMapper.deleteById(id);
    }
}
