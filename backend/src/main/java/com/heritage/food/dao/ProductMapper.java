package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Product;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {

    Page<Product> selectProductList(Page<Product> page, 
                                   @Param("category") String category, 
                                   @Param("keyword") String keyword, 
                                   @Param("sortBy") String sortBy, 
                                   @Param("sortOrder") String sortOrder);

    List<Product> selectHotProducts(@Param("limit") int limit);

    List<Product> selectRecommendProducts(@Param("limit") int limit);

    List<String> selectAllCategories();
}
