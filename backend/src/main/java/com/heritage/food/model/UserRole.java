package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;

@TableName("tb_user_role")
@Data
public class UserRole {
    private Long id;
    private Long userId;
    private Long roleId;
    private Date createTime;
}
