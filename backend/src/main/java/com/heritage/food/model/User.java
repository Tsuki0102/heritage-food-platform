package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;

@TableName("tb_user")

@Data
public class User {
    private Long id;
    private String nickname;
    private String password;
    private String phone;
    private Integer gender;
    private String region;
    private String tasteTags;
    private String avatar;
    private Date registerTime;
    private Integer status;
    private Integer isAdmin;
}