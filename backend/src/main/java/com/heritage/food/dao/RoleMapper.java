package com.heritage.food.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heritage.food.model.Role;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

public interface RoleMapper extends BaseMapper<Role> {
    
    @Select("SELECT r.* FROM tb_role r " +
            "INNER JOIN tb_user_role ur ON r.id = ur.role_id " +
            "WHERE ur.user_id = #{userId}")
    List<Role> selectRolesByUserId(@Param("userId") Long userId);
    
    @Select("SELECT r.* FROM tb_role r " +
            "INNER JOIN tb_user_role ur ON r.id = ur.role_id " +
            "WHERE ur.user_id = #{userId} AND r.status = 1")
    List<Role> selectActiveRolesByUserId(@Param("userId") Long userId);
}
