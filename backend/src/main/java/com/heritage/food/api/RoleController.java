package com.heritage.food.api;

import com.heritage.food.model.Role;
import com.heritage.food.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/admin/roles")
public class RoleController {
    
    @Autowired
    private RoleService roleService;
    
    @GetMapping
    public Map<String, Object> getAllRoles() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Role> roles = roleService.getAllRoles();
            result.put("data", roles);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取角色列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @GetMapping("/{id}")
    public Role getRoleById(@PathVariable Long id) {
        return roleService.getRoleById(id);
    }
    
    @PostMapping
    public Map<String, Object> saveRole(@RequestBody Role role) {
        Map<String, Object> result = new HashMap<>();
        try {
            roleService.saveRole(role);
            result.put("success", true);
            result.put("message", "角色创建成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "角色创建失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @PutMapping
    public Map<String, Object> updateRole(@RequestBody Role role) {
        Map<String, Object> result = new HashMap<>();
        try {
            roleService.updateRole(role);
            result.put("success", true);
            result.put("message", "角色更新成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "角色更新失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteRole(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        try {
            roleService.deleteRole(id);
            result.put("success", true);
            result.put("message", "角色删除成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "角色删除失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @GetMapping("/user/{userId}")
    public List<Role> getRolesByUserId(@PathVariable Long userId) {
        return roleService.getRolesByUserId(userId);
    }
    
    @PostMapping("/user/{userId}/assign")
    public Map<String, Object> assignRolesToUser(@PathVariable Long userId, @RequestBody List<Long> roleIds) {
        Map<String, Object> result = new HashMap<>();
        try {
            roleService.assignRolesToUser(userId, roleIds);
            result.put("success", true);
            result.put("message", "角色分配成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "角色分配失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @PostMapping("/user/{userId}/remove")
    public Map<String, Object> removeRolesFromUser(@PathVariable Long userId, @RequestBody List<Long> roleIds) {
        Map<String, Object> result = new HashMap<>();
        try {
            roleService.removeRolesFromUser(userId, roleIds);
            result.put("success", true);
            result.put("message", "角色移除成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "角色移除失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @PostMapping("/{roleId}/permissions")
    public Map<String, Object> assignPermissionsToRole(@PathVariable Long roleId, @RequestBody List<Long> permissionIds) {
        Map<String, Object> result = new HashMap<>();
        try {
            roleService.assignPermissionsToRole(roleId, permissionIds);
            result.put("success", true);
            result.put("message", "权限分配成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "权限分配失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
    
    @DeleteMapping("/{roleId}/permissions")
    public Map<String, Object> removePermissionsFromRole(@PathVariable Long roleId, @RequestBody List<Long> permissionIds) {
        Map<String, Object> result = new HashMap<>();
        try {
            roleService.removePermissionsFromRole(roleId, permissionIds);
            result.put("success", true);
            result.put("message", "权限移除成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "权限移除失败: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
}
