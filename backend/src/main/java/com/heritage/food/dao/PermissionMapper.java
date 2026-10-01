package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heritage.food.model.Permission;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

public interface PermissionMapper extends BaseMapper<Permission> {
    
    @Select("SELECT p.* FROM tb_permission p " +
            "INNER JOIN tb_role_permission rp ON p.id = rp.permission_id " +
            "WHERE rp.role_id = #{roleId}")
    List<Permission> selectPermissionsByRoleId(@Param("roleId") Long roleId);
    
    @Select("SELECT DISTINCT p.* FROM tb_permission p " +
            "INNER JOIN tb_role_permission rp ON p.id = rp.permission_id " +
            "INNER JOIN tb_user_role ur ON rp.role_id = ur.role_id " +
            "WHERE ur.user_id = #{userId} AND p.status = 1")
    List<Permission> selectPermissionsByUserId(@Param("userId") Long userId);
    
    @Select("SELECT p.* FROM tb_permission p WHERE p.parent_id = 0 AND p.status = 1 ORDER BY p.id")
    List<Permission> selectRootPermissions();
    
    @Select("SELECT p.* FROM tb_permission p WHERE p.parent_id = #{parentId} AND p.status = 1 ORDER BY p.id")
    List<Permission> selectPermissionsByParentId(@Param("parentId") Long parentId);
    
    @Select("SELECT p.permission_key FROM tb_permission p " +
            "INNER JOIN tb_role_permission rp ON p.id = rp.permission_id " +
            "INNER JOIN tb_user_role ur ON rp.role_id = ur.role_id " +
            "WHERE ur.user_id = #{userId} AND p.status = 1")
    List<String> selectPermissionKeysByUserId(@Param("userId") Long userId);
}
