package com.heritage.food.api;

import com.heritage.food.model.Permission;
import com.heritage.food.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/admin/permissions")
public class PermissionController {
    
    @Autowired
    private PermissionService permissionService;
    
    @GetMapping
    public Map<String, Object> getAllPermissions() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Permission> permissions = permissionService.getAllPermissions();
            result.put("data", permissions);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取权限列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @GetMapping("/{id}")
    public Permission getPermissionById(@PathVariable Long id) {
        return permissionService.getPermissionById(id);
    }
    
    @PostMapping
    public Map<String, Object> savePermission(@RequestBody Permission permission) {
        Map<String, Object> result = new HashMap<>();
        try {
            permissionService.savePermission(permission);
            result.put("success", true);
            result.put("message", "权限创建成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "权限创建失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @PutMapping
    public Map<String, Object> updatePermission(@RequestBody Permission permission) {
        Map<String, Object> result = new HashMap<>();
        try {
            permissionService.updatePermission(permission);
            result.put("success", true);
            result.put("message", "权限更新成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "权限更新失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @DeleteMapping("/{id}")
    public Map<String, Object> deletePermission(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        try {
            permissionService.deletePermission(id);
            result.put("success", true);
            result.put("message", "权限删除成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "权限删除失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @GetMapping("/role/{roleId}")
    public List<Permission> getPermissionsByRoleId(@PathVariable Long roleId) {
        return permissionService.getPermissionsByRoleId(roleId);
    }
    
    @GetMapping("/user/{userId}")
    public List<Permission> getPermissionsByUserId(@PathVariable Long userId) {
        return permissionService.getPermissionsByUserId(userId);
    }
    
    @GetMapping("/tree")
    public List<Permission> getPermissionTree() {
        return permissionService.getPermissionTree();
    }
    
    @GetMapping("/user/{userId}/keys")
    public List<String> getPermissionKeysByUserId(@PathVariable Long userId) {
        return permissionService.getPermissionKeysByUserId(userId);
    }
    
    @GetMapping("/user/{userId}/check/{permissionKey}")
    public Map<String, Object> hasPermission(@PathVariable Long userId, @PathVariable String permissionKey) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean hasPermission = permissionService.hasPermission(userId, permissionKey);
            result.put("hasPermission", hasPermission);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "权限检查失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
}
