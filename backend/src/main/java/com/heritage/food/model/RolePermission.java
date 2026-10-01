package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;

@TableName("tb_role_permission")
@Data
public class RolePermission {
    private Long id;
    private Long roleId;
    private Long permissionId;
    private Date createTime;
}
