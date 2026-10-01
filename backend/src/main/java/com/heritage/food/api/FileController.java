package com.heritage.food.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@RestController
@RequestMapping("/api/file")
public class FileController {

    @Value("${file.upload.path}")
    private String uploadRoot;

    @PostMapping("/upload")
    public String uploadFile(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return "文件为空";
        }

        try {
            String originalName = file.getOriginalFilename();
            if (originalName == null || originalName.isEmpty()) {
                return "无效文件名";
            }

            int lastDotIndex = originalName.lastIndexOf(".");
            String suffix = lastDotIndex > 0 ? originalName.substring(lastDotIndex) : ".jpg";
            String fileName = UUID.randomUUID() + suffix;

            File uploadDir = new File(uploadRoot);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File destFile = new File(uploadDir, fileName);
            file.transferTo(destFile);

            return "/file/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
            return "上传失败";
        }
    }
}