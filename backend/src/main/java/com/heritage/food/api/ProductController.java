package com.heritage.food.api;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.Product;
import com.heritage.food.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping("/list")
    public Map<String, Object> getProductList(@RequestParam int page, 
                                             @RequestParam int pageSize, 
                                             @RequestParam(required = false) String category, 
                                             @RequestParam(required = false) String keyword, 
                                             @RequestParam(required = false) String sortBy, 
                                             @RequestParam(required = false) String sortOrder) {
        Page<Product> productPage = productService.getProductList(page, pageSize, category, keyword, sortBy, sortOrder);
        Map<String, Object> result = new HashMap<>();
        result.put("records", productPage.getRecords());
        result.put("total", productPage.getTotal());
        result.put("page", page);
        result.put("pageSize", pageSize);
        result.put("totalPages", productPage.getPages());
        return result;
    }

    @GetMapping("/{id}")
    public Product getProductById(@PathVariable Integer id) {
        return productService.getProductById(id);
    }

    @GetMapping("/categories")
    public List<String> getProductCategories() {
        return productService.getProductCategories();
    }

    @GetMapping("/search")
    public Map<String, Object> searchProducts(@RequestParam String keyword, 
                                            @RequestParam int page, 
                                            @RequestParam int pageSize) {
        Page<Product> productPage = productService.getProductList(page, pageSize, null, keyword, null, null);
        Map<String, Object> result = new HashMap<>();
        result.put("records", productPage.getRecords());
        result.put("total", productPage.getTotal());
        result.put("page", page);
        result.put("pageSize", pageSize);
        result.put("totalPages", productPage.getPages());
        return result;
    }

    @GetMapping("/category")
    public Map<String, Object> getProductsByCategory(@RequestParam String category, 
                                                   @RequestParam int page, 
                                                   @RequestParam int pageSize) {
        Page<Product> productPage = productService.getProductList(page, pageSize, category, null, null, null);
        Map<String, Object> result = new HashMap<>();
        result.put("records", productPage.getRecords());
        result.put("total", productPage.getTotal());
        result.put("page", page);
        result.put("pageSize", pageSize);
        result.put("totalPages", productPage.getPages());
        return result;
    }

    @GetMapping("/hot")
    public List<Product> getHotProducts(@RequestParam int limit) {
        return productService.getHotProducts(limit);
    }

    @GetMapping("/recommend")
    public List<Product> getRecommendProducts(@RequestParam int limit) {
        return productService.getRecommendProducts(limit);
    }

    @PostMapping
    public void saveProduct(@RequestBody Product product) {
        productService.saveProduct(product);
    }

    @PutMapping
    public void updateProduct(@RequestBody Product product) {
        productService.updateProduct(product);
    }

    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Integer id) {
        productService.deleteProduct(id);
    }
}
