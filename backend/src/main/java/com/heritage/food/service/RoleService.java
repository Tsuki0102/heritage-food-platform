package com.heritage.food.service;

import com.heritage.food.model.Role;
import java.util.List;

public interface RoleService {
    
    List<Role> getAllRoles();
    
    Role getRoleById(Long id);
    
    void saveRole(Role role);
    
    void updateRole(Role role);
    
    void deleteRole(Long id);
    
    List<Role> getRolesByUserId(Long userId);
    
    void assignRolesToUser(Long userId, List<Long> roleIds);
    
    void removeRolesFromUser(Long userId, List<Long> roleIds);
    
    void assignPermissionsToRole(Long roleId, List<Long> permissionIds);
    
    void removePermissionsFromRole(Long roleId, List<Long> permissionIds);
}
