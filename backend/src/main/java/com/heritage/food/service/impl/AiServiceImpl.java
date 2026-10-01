package com.heritage.food.service.impl;

import com.heritage.food.service.AiService;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class AiServiceImpl implements AiService {

    private static final Logger log = LoggerFactory.getLogger(AiServiceImpl.class);
    private static final String API_URL = "https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation";
    private static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");

    @Value("${dashscope.api-key}")
    private String apiKey;

    @Value("${dashscope.model:qwen-turbo}")
    private String model;

    private final OkHttpClient client;

    public AiServiceImpl() {
        this.client = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(60, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .build();
    }

    @Override
    public String explainFood(String foodName) {
        if (foodName == null || foodName.trim().isEmpty()) {
            return "请提供美食名称";
        }

        String prompt = buildPrompt(foodName.trim());
        String requestBody = buildRequestBody(prompt);

        Request request = new Request.Builder()
                .url(API_URL)
                .addHeader("Authorization", "Bearer " + apiKey)
                .addHeader("Content-Type", "application/json")
                .post(RequestBody.create(requestBody, JSON))
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                log.error("API调用失败: code={}, message={}", response.code(), response.message());
                return "AI服务暂时不可用，请稍后再试。";
            }

            String responseBody = response.body() != null ? response.body().string() : "";
            return parseResponse(responseBody);

        } catch (IOException e) {
            log.error("网络请求异常: {}", e.getMessage(), e);
            return "网络异常，请检查网络后重试。";
        } catch (Exception e) {
            log.error("系统异常: {}", e.getMessage(), e);
            return "系统异常，请稍后再试。";
        }
    }

    private String buildPrompt(String foodName) {
        return String.format(
            "你是非遗美食专家，介绍【%s】这道美食。\n" +
            "请按以下结构介绍，500字以内，口语化：\n" +
            "①起源历史\n" +
            "②制作工艺\n" +
            "③文化价值\n" +
            "④传承故事",
            foodName
        );
    }

    private String buildRequestBody(String prompt) {
        Map<String, Object> requestMap = Map.of(
            "model", model,
            "input", Map.of("prompt", prompt)
        );
        return com.alibaba.fastjson2.JSON.toJSONString(requestMap);
    }

    private String parseResponse(String responseBody) {
        try {
            com.alibaba.fastjson2.JSONObject json = com.alibaba.fastjson2.JSON.parseObject(responseBody);
            com.alibaba.fastjson2.JSONObject output = json.getJSONObject("output");
            if (output != null) {
                String text = output.getString("text");
                if (text != null && !text.isEmpty()) {
                    return text.trim();
                }
            }
            com.alibaba.fastjson2.JSONObject error = json.getJSONObject("error");
            if (error != null) {
                String message = error.getString("message");
                log.warn("API返回错误: {}", message);
                return "AI服务返回异常: " + message;
            }
            return "未获取到有效回复";
        } catch (Exception e) {
            log.error("解析响应失败: {}, body={}", e.getMessage(), responseBody);
            return "解析响应失败，请稍后再试。";
        }
    }
}
