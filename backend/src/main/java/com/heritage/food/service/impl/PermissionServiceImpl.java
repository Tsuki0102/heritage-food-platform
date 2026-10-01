package com.heritage.food.service.impl;

import com.heritage.food.dao.PermissionMapper;
import com.heritage.food.model.Permission;
import com.heritage.food.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class PermissionServiceImpl implements PermissionService {
    
    @Autowired
    private PermissionMapper permissionMapper;
    
    @Override
    public List<Permission> getAllPermissions() {
        com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<Permission> queryWrapper = new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<>();
        queryWrapper.eq("status", 1);
        return permissionMapper.selectList(queryWrapper);
    }
    
    @Override
    public Permission getPermissionById(Long id) {
        return permissionMapper.selectById(id);
    }
    
    @Override
    public void savePermission(Permission permission) {
        permissionMapper.insert(permission);
    }
    
    @Override
    public void updatePermission(Permission permission) {
        permissionMapper.updateById(permission);
    }
    
    @Override
    public void deletePermission(Long id) {
        permissionMapper.deleteById(id);
    }
    
    @Override
    public List<Permission> getPermissionsByRoleId(Long roleId) {
        return permissionMapper.selectPermissionsByRoleId(roleId);
    }
    
    @Override
    public List<Permission> getPermissionsByUserId(Long userId) {
        return permissionMapper.selectPermissionsByUserId(userId);
    }
    
    @Override
    public List<Permission> getPermissionTree() {
        List<Permission> rootPermissions = permissionMapper.selectRootPermissions();
        for (Permission root : rootPermissions) {
            buildPermissionTree(root);
        }
        return rootPermissions;
    }
    
    private void buildPermissionTree(Permission parent) {
        List<Permission> children = permissionMapper.selectPermissionsByParentId(parent.getId());
        if (children != null && !children.isEmpty()) {
            parent.setChildren(children);
            for (Permission child : children) {
                buildPermissionTree(child);
            }
        }
    }
    
    @Override
    public List<String> getPermissionKeysByUserId(Long userId) {
        return permissionMapper.selectPermissionKeysByUserId(userId);
    }
    
    @Override
    public boolean hasPermission(Long userId, String permissionKey) {
        List<String> permissionKeys = getPermissionKeysByUserId(userId);
        return permissionKeys != null && permissionKeys.contains(permissionKey);
    }
}
