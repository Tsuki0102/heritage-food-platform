package com.heritage.food.service;

import com.heritage.food.model.Permission;
import java.util.List;

public interface PermissionService {
    
    List<Permission> getAllPermissions();
    
    Permission getPermissionById(Long id);
    
    void savePermission(Permission permission);
    
    void updatePermission(Permission permission);
    
    void deletePermission(Long id);
    
    List<Permission> getPermissionsByRoleId(Long roleId);
    
    List<Permission> getPermissionsByUserId(Long userId);
    
    List<Permission> getPermissionTree();
    
    List<String> getPermissionKeysByUserId(Long userId);
    
    boolean hasPermission(Long userId, String permissionKey);
}
