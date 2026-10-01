package com.heritage.food.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.heritage.food.dao.RoleMapper;
import com.heritage.food.dao.RolePermissionMapper;
import com.heritage.food.dao.UserRoleMapper;
import com.heritage.food.model.Role;
import com.heritage.food.model.RolePermission;
import com.heritage.food.model.UserRole;
import com.heritage.food.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.ArrayList;
import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {
    
    @Autowired
    private RoleMapper roleMapper;
    
    @Autowired
    private RolePermissionMapper rolePermissionMapper;
    
    @Autowired
    private UserRoleMapper userRoleMapper;
    
    @Override
    public List<Role> getAllRoles() {
        com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<Role> queryWrapper = new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<>();
        queryWrapper.eq("status", 1);
        return roleMapper.selectList(queryWrapper);
    }
    
    @Override
    public Role getRoleById(Long id) {
        return roleMapper.selectById(id);
    }
    
    @Override
    public void saveRole(Role role) {
        roleMapper.insert(role);
    }
    
    @Override
    public void updateRole(Role role) {
        roleMapper.updateById(role);
    }
    
    @Override
    public void deleteRole(Long id) {
        roleMapper.deleteById(id);
    }
    
    @Override
    public List<Role> getRolesByUserId(Long userId) {
        return roleMapper.selectRolesByUserId(userId);
    }
    
    @Override
    @Transactional
    public void assignRolesToUser(Long userId, List<Long> roleIds) {
        QueryWrapper<UserRole> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        userRoleMapper.delete(queryWrapper);
        
        for (Long roleId : roleIds) {
            UserRole userRole = new UserRole();
            userRole.setUserId(userId);
            userRole.setRoleId(roleId);
            userRoleMapper.insert(userRole);
        }
    }
    
    @Override
    @Transactional
    public void removeRolesFromUser(Long userId, List<Long> roleIds) {
        QueryWrapper<UserRole> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId).in("role_id", roleIds);
        userRoleMapper.delete(queryWrapper);
    }
    
    @Override
    @Transactional
    public void assignPermissionsToRole(Long roleId, List<Long> permissionIds) {
        QueryWrapper<RolePermission> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id", roleId);
        rolePermissionMapper.delete(queryWrapper);
        
        for (Long permissionId : permissionIds) {
            RolePermission rolePermission = new RolePermission();
            rolePermission.setRoleId(roleId);
            rolePermission.setPermissionId(permissionId);
            rolePermissionMapper.insert(rolePermission);
        }
    }
    
    @Override
    @Transactional
    public void removePermissionsFromRole(Long roleId, List<Long> permissionIds) {
        QueryWrapper<RolePermission> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id", roleId).in("permission_id", permissionIds);
        rolePermissionMapper.delete(queryWrapper);
    }
}
