package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;
import java.util.List;

@TableName("tb_role")
@Data
public class Role {
    private Long id;
    private String roleName;
    private String roleKey;
    private String description;
    private Integer status;
    private Date createTime;
    private Date updateTime;
    
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private List<Permission> permissions;
}
