package com.heritage.food.config;

import com.heritage.food.interceptor.PermissionInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private PermissionInterceptor permissionInterceptor;

    /** 上传文件目录，见 application.yml 的 app.upload-dir */
    @Value("${app.upload-dir}")
    private String uploadDir;

    /** 前端图片素材目录（演示图片兜底），见 application.yml 的 app.frontend-images-dir */
    @Value("${app.frontend-images-dir}")
    private String frontendImagesDir;

    @Override
    public void addResourceHandlers(@NonNull ResourceHandlerRegistry registry) {
        String uploadLocation = "file:" + uploadDir.replace('\\', '/') + "/";
        // 配置上传文件目录：/uploads/** 与 /file/**（上传接口 /api/file/upload 返回的直链）
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadLocation);
        registry.addResourceHandler("/file/**")
                .addResourceLocations(uploadLocation);
        // 配置图片目录，指向前端的 public/images 目录
        registry.addResourceHandler("/images/**")
                .addResourceLocations("file:" + frontendImagesDir.replace('\\', '/') + "/");
    }

    @Override
    public void addInterceptors(@NonNull InterceptorRegistry registry) {
        registry.addInterceptor(permissionInterceptor)
                .addPathPatterns("/api/admin/**")
                .excludePathPatterns("/api/admin/login", "/api/admin/permissions/**", "/api/admin/roles/**");
    }
}
