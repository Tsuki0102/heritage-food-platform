# REST API 接口文档

> 后端统一前缀 `/api`,返回 JSON。除特别说明外,成功返回实体或列表,失败由 `GlobalExceptionHandler` 兜底返回 500 JSON。
> 开发期通过 Vite 代理访问(`/api → http://localhost:8088`),生产环境由 Nginx 转发。
> 当前版本未启用接口级鉴权,身份参数(如 `userId`)由前端显式传入。

## 目录

- [AI 讲解](#ai-讲解)
- [用户](#用户-user)
- [非遗美食](#非遗美食-food)
- [店铺](#店铺-store)
- [商城商品](#商城商品-product)
- [购物车](#购物车-cart)
- [订单](#订单-order)
- [支付](#支付-payment)
- [社区](#社区-community)
- [文件上传](#文件上传-file)
- [商家工作台](#商家工作台-merchant)
- [管理端:商家管理](#管理端商家管理-adminmerchants)
- [管理端:角色权限与系统](#管理端角色权限与系统)

---

## AI 讲解

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/ai/food/explain?foodName={name}` | 调用通义千问,按"起源历史/制作工艺/文化价值/传承故事"四段生成讲解文本 |

## 用户 `/user`

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/user` | 用户列表 |
| GET | `/api/user/{id}` | 用户详情 |
| GET | `/api/user/phone/{phone}` | 按手机号查询(前端登录的数据基础,不存在返回 404/错误) |
| POST | `/api/user` | 注册/新建用户(演示登录的自动注册即调此接口) |
| PUT | `/api/user` | 更新用户信息 |
| DELETE | `/api/user/{id}` | 删除用户 |

## 非遗美食 `/food`

| 方法 | 路径 | 参数 | 说明 |
|---|---|---|---|
| GET | `/api/food/{id}` | - | 美食详情 |
| GET | `/api/food/list` | `page`、`size` 必填;`region`、`taste`、`heritage_level`、`keyword` 可选 | 分页筛选(注意参数名为下划线 `heritage_level`) |
| GET | `/api/food/hot/list` | - | 热门美食列表 |
| GET | `/api/food/region/{region}` | - | 按地区查询 |
| GET | `/api/food/taste/{taste}` | - | 按口味查询 |
| GET | `/api/food/{id}/ratings` | - | 美食的评价列表 |
| POST | `/api/food/rating/{foodId}` | Body: `UserRating` | 提交评分/评价 |
| POST | `/api/food` | Body: `Food` | 新增(管理) |
| PUT | `/api/food` | Body: `Food` | 更新(管理) |
| DELETE | `/api/food/{id}` | - | 删除(管理) |

## 店铺 `/store`

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/store/{id}` | 店铺详情(含招牌菜、活动、评价) |
| GET | `/api/store/list` | 店铺分页列表 |
| GET | `/api/store/all` | 全量列表(地图点位使用) |
| POST / PUT | `/api/store` | 新增 / 更新(管理) |
| DELETE | `/api/store/{id}` | 删除(管理) |

## 商城商品 `/product`

| 方法 | 路径 | 参数 | 说明 |
|---|---|---|---|
| GET | `/api/product/list` | `page`、`pageSize` 必填;`category`、`keyword`、`sortBy`、`sortOrder` 可选 | 分页列表(返回含 `records/total/page/pageSize/totalPages` 的包装结构) |
| GET | `/api/product/{id}` | - | 商品详情 |
| GET | `/api/product/categories` | - | 分类列表 |
| GET | `/api/product/search` | `keyword`、`page`、`pageSize` | 关键词搜索 |
| GET | `/api/product/category` | `category`、`page`、`pageSize` | 按分类查询 |
| GET | `/api/product/hot` | - | 热门商品 |
| GET | `/api/product/recommend` | - | 推荐商品 |
| POST / PUT | `/api/product` | Body: `Product` | 新增 / 更新(管理) |
| DELETE | `/api/product/{id}` | - | 删除(管理) |

## 购物车 `/cart`

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/cart?userId=` | 购物车列表 |
| POST | `/api/cart` | 添加商品项 |
| PUT | `/api/cart/{id}` | 修改数量 |
| DELETE | `/api/cart/{id}` | 删除单项 |
| DELETE | `/api/cart/clear?userId=` | 清空购物车 |
| GET | `/api/cart/count?userId=` | 购物车商品计数 |

## 订单 `/order`

| 方法 | 路径 | 参数 | 说明 |
|---|---|---|---|
| POST | `/api/order?userId=` | Body: `{ items: [...], receiverName, receiverPhone, receiverAddress, remark }` | 创建订单(状态:0 待支付/1 已支付/2 已发货/3 已完成/4 已取消) |
| GET | `/api/order/list` | `userId`、`page`、`pageSize` 必填;`status` 可选 | 分页订单列表 |
| GET | `/api/order/{id}` | - | 按 ID 查询 |
| GET | `/api/order/no/{orderNo}` | - | 按订单号查询 |
| PUT | `/api/order/{id}/cancel` | - | 取消订单 |
| PUT | `/api/order/{id}/receive` | - | 确认收货 |

## 支付 `/payment`(模拟)

| 方法 | 路径 | 说明 |
|---|---|---|
| POST | `/api/payment?userId=` | 创建支付单并模拟支付成功,支付单号规则 `PAY+时间戳+UUID`;成功后订单置为已支付 |
| GET | `/api/payment/{paymentNo}` | 按支付单号查询 |
| GET | `/api/payment/order/{orderId}` | 按订单查询支付记录 |
| DELETE | `/api/payment/{paymentNo}` | 删除支付记录 |

> 支付状态:0 待支付 / 1 成功 / 2 失败。未接入真实支付渠道,见 [architecture.md §4.2](architecture.md)。

## 社区 `/community`

| 方法 | 路径 | 参数 | 说明 |
|---|---|---|---|
| GET | `/api/community/{id}` | - | 帖子详情(含评论) |
| GET | `/api/community/list` | `page`、`size` | 分页列表 |
| GET | `/api/community/all` | - | 全量列表 |
| POST | `/api/community` | Body: `CommunityPost` | 发帖(类型:`food` 美食帖 / `store` 探店帖 / `other` 其他) |
| PUT | `/api/community` | Body: `CommunityPost` | 更新帖子 |
| DELETE | `/api/community/{id}` | - | 删除帖子 |

## 文件上传 `/file`

| 方法 | 路径 | 说明 |
|---|---|---|
| POST | `/api/file/upload` | `multipart/form-data`,字段名 `file`;UUID 重命名保存至后端 `uploads/`,返回可直连访问的路径(如 `/file/xxx.jpg`) |

## 商家工作台 `/merchant`

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/merchant/workspace?userId=` | 工作台聚合数据(店铺资料、商品/内容提交、结算、提现) |
| GET | `/api/merchant/applications/overview?userId=` | 各类申请概览 |
| POST | `/api/merchant/onboarding-applications` | 提交入驻申请 |
| POST | `/api/merchant/qualification-applications` | 提交资质/非遗认证申请 |
| POST | `/api/merchant/products` | 提交商品(待平台审核) |
| PUT | `/api/merchant/products/{id}/status` | 商家侧更新商品状态(上/下架) |
| POST | `/api/merchant/contents` | 提交内容(待平台审核,含敏感词命中标记) |
| PUT | `/api/merchant/profile` | 更新店铺资料 |
| POST | `/api/merchant/withdrawals` | 提现申请 |

## 管理端:商家管理 `/admin/merchants`

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/admin/merchants/workspace` | 商家管理聚合工作台 |
| PUT | `/api/admin/merchants/accounts/{userId}/merchant-role` | 授予/撤销商家角色 |
| PUT | `/api/admin/merchants/accounts/{userId}/profile` | 调整商家档案(佣金比例、状态等) |
| PUT | `/api/admin/merchants/onboarding/{id}/review` | 入驻申请审核 |
| PUT | `/api/admin/merchants/qualifications/{id}/review` | 资质认证审核 |
| PUT | `/api/admin/merchants/settlements/{id}/status` | 结算单状态 |
| PUT | `/api/admin/merchants/withdrawals/{id}/status` | 提现审核 |
| PUT | `/api/admin/merchants/products/{id}/status` | 商品上架/下架审核 |
| PUT | `/api/admin/merchants/contents/{id}/status` | 内容审核 |
| PUT | `/api/admin/merchants/reviews/{id}/status` | 评价审核(敏感词命中处理) |
| PUT | `/api/admin/merchants/artisans/{id}/status` | 匠人认证审核 |
| POST / DELETE | `/api/admin/merchants/sensitive-words` | 敏感词库增删 |

## 管理端:角色权限与系统

**角色 `/api/admin/roles`**:列表、`{id}` 详情、新增、更新、删除;`GET /user/{userId}` 查用户角色;`POST/DELETE /user/{userId}/assign|remove` 授权/移除;`POST/DELETE /{roleId}/permissions` 绑定/解绑权限。

**权限 `/api/admin/permissions`**:列表、`{id}` 详情、新增、更新、删除;`GET /role/{roleId}`、`GET /user/{userId}` 查关联;`GET /tree` 权限树;`GET /user/{userId}/keys` 用户权限标识集合;`GET /user/{userId}/check/{permissionKey}` 权限校验。

**系统设置 `/api/admin/settings`**:`GET` 读取、`PUT` 更新(存于 `tb_settings`)。

**统计 `/api/admin/statistics`**:

| 方法 | 路径 | 参数 | 说明 |
|---|---|---|---|
| GET | `/overview` | - | 总览指标 |
| GET | `/user-trend` | `startDate`、`endDate` 可选 | 用户增长趋势 |
| GET | `/food-category` | - | 美食品类分布 |
| GET | `/user-region` | - | 用户地域分布 |
| GET | `/activity` | - | 平台活跃度 |
| GET | `/top-foods` | - | 热门美食 Top |
| GET | `/export` | `startDate`、`endDate` 可选 | 报表导出(文件流) |

---

## 备注

1. **统一响应**:本项目管理端部分接口返回 `Page<T>` 或 Map 包装,用户端多数接口直接返回实体/列表,前端 Axios 拦截器已统一剥壳 `response.data`。
2. **鉴权**:预留了 `@RequirePermission` 注解 + `PermissionInterceptor`(拦截 `/api/admin/**`),当前未在控制器上标注,详见 [architecture.md §4.1](architecture.md)。
3. **错误响应示例**(全局异常兜底):

```json
{
  "timestamp": "2026-10-01T12:00:00.000+00:00",
  "status": 500,
  "error": "Internal Server Error",
  "exception": "java.lang.RuntimeException",
  "message": "...",
  "stackTrace": "…(截断至 1000 字符)"
}
```
