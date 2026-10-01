package com.heritage.food.config;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public void handleException(Exception e, HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("application/json;charset=UTF-8");
        
        Map<String, Object> error = new HashMap<>();
        error.put("timestamp", System.currentTimeMillis());
        error.put("status", 500);
        error.put("error", "Internal Server Error");
        error.put("exception", e.getClass().getName());
        error.put("message", e.getMessage());
        
        StringBuilder stackTrace = new StringBuilder();
        for (StackTraceElement element : e.getStackTrace()) {
            if (stackTrace.length() > 1000) break; // 限制长度
            stackTrace.append(element.toString()).append("\n");
        }
        error.put("stackTrace", stackTrace.toString());
        
        PrintWriter writer = response.getWriter();
        writer.write(com.alibaba.fastjson2.JSON.toJSONString(error));
        writer.flush();
    }
}