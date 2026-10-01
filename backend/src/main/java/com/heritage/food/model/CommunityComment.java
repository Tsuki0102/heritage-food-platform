package com.heritage.food.model;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;

@Data
@TableName("tb_community_comment")
public class CommunityComment {
    private Long id;
    private Long postId;
    private Long userId;
    private String content;
    private Date createTime;
    
    @TableField(exist = false)
    private String nickname;
    
    @TableField(exist = false)
    private String avatar;
}