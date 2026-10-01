package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;
import java.util.List;

@TableName("tb_permission")
@Data
public class Permission {
    private Long id;
    private String permissionName;
    private String permissionKey;
    private String resourceType;
    private String resourceUrl;
    private Long parentId;
    private String description;
    private Integer status;
    private Date createTime;
    private Date updateTime;
    
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private List<Permission> children;
}
