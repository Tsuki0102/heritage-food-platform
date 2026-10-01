# 系统架构与模块设计

> 适用版本:当前仓库 master 分支。配合 [README](../README.md)、[api.md](api.md)、[database.md](database.md) 阅读。

## 1. 总体架构

系统采用前后端分离的单体架构:

- **前端** `frontend`:Vue 3 SPA,按角色划分为用户端 / 商家端 / 管理端三套路由与布局;
- **后端** `backend`:Spring Boot 2.7.15 单体服务(端口 8088),RESTful 风格接口,统一 `/api` 前缀;
- **数据库**:MySQL 8.0,单库 `feiyi_food_platform`,31 张表;
- **外部服务**:阿里云 DashScope(通义千问 `qwen-turbo`),仅用于 AI 美食讲解。

开发期前端 Vite Dev Server(3000 端口)将 `/api`、`/file` 反向代理到后端 8088,因此前端代码中不需要出现后端主机地址;生产部署时由 Nginx 承担同样的路由职责(见 [deployment.md](deployment.md))。

## 2. 后端模块划分

```
com.heritage.food
├── Application          # 启动类(已排除 Redis 自动配置)
├── api/                 # Controller 层,17 个控制器
├── service/             # 业务接口 + impl 实现
├── dao/                 # MyBatis-Plus Mapper(含 resources/mapper/*.xml)
├── model/               # 实体(与 tb_* 表一一对应)
├── dto/                 # 数据传输对象
├── config/              # 配置与横切组件(见下表)
├── interceptor/         # PermissionInterceptor(RBAC)
├── annotation/          # @RequirePermission
└── utils/               # 工具类
```

### 2.1 Controller 一览

| Controller | 路径前缀 | 职责 |
|---|---|---|
| UserController | `/api/user` | 用户 CRUD、按手机号查询(登录的数据基础) |
| FoodController | `/api/food` | 非遗美食 CRUD、筛选、评分、收藏/浏览计数 |
| StoreController | `/api/store` | 店铺 CRUD、列表 |
| ProductController | `/api/product` | 商城商品 CRUD、搜索、分类、热门/推荐 |
| CartController | `/api/cart` | 购物车增删改查、清空、计数 |
| OrderController | `/api/order` | 创建订单、列表、详情、取消、确认收货 |
| PaymentController | `/api/payment` | 支付单创建/查询(模拟支付)、删除 |
| CommunityController | `/api/community` | 社区帖子 CRUD、分页 |
| FileController | `/api/file` | 图片/附件上传(UUID 重命名) |
| AiController | `/api` | `GET /api/ai/food/explain` AI 美食讲解 |
| MerchantController | `/api/merchant` | 商家工作台:入驻、资质、商品/内容提交、提现 |
| AdminMerchantController | `/api/admin/merchants` | 平台侧商家全流程审核、敏感词库 |
| RoleController | `/api/admin/roles` | 角色管理、用户授权 |
| PermissionController | `/api/admin/permissions` | 权限管理、权限树、权限校验 |
| SettingsController | `/api/admin/settings` | 系统参数(`tb_settings`) |
| StatisticsController | `/api/admin/statistics` | 7 类统计聚合 + 报表导出 |

完整接口清单见 [api.md](api.md)。

### 2.2 配置与横切组件(config/)

| 组件 | 说明 |
|---|---|
| `SecurityConfig` | Spring Security 仅承担 CORS(全放开)与 CSRF 关闭,所有请求 `permitAll`;真正的访问控制由拦截器完成 |
| `CorsConfig` | MVC 层 CORS 配置(与 SecurityConfig 叠加,双保险) |
| `WebConfig` | 注册静态资源映射与权限拦截器 |
| `MybatisPlusConfig` | 分页插件 |
| `GlobalExceptionHandler` | `@RestControllerAdvice` 全局异常兜底,返回 500 JSON(含堆栈摘要) |
| `MerchantRoleInitializer` | 启动时确保 `tb_role` 存在 merchant 角色 |
| `MerchantSchemaInitializer` | 启动时自动 `CREATE TABLE IF NOT EXISTS` 商家域 10+ 张表(保证新环境可跑通) |

### 2.3 静态资源与上传文件

| 映射 | 目录 | 用途 |
|---|---|---|
| `/uploads/**` | 后端 `uploads/` | 用户上传文件(头像、帖子图片等) |
| `/file/**` | 后端 `uploads/` | 上传接口返回的直链(与 uploads 同源) |
| `/images/**` | 前端 `public/images/` | 演示图片素材(后端侧兜底) |

数据库中的演示数据大量引用 `/images/xxx.jpg` 路径,这些文件位于前端 `public/images/`(开发期由 Vite 直接提供);`/uploads/**`、`/file/**` 则由后端提供。路径解析规则统一收敛在前端 `src/utils/index.ts` 的 `resolveAvatarUrl` 中。

## 3. 前端模块划分

```
src/
├── main.ts / App.vue
├── router/index.ts        # 路由表 + 全局守卫(requiresAuth / requiresAdmin)
├── api/index.ts           # Axios 实例(响应拦截器直接返回 response.data)
│   └── modules            # user/food/store/product/cart/order/payment/
│                          # merchant/community 各领域 API
├── stores/                # Pinia:用户、购物车、订单、社区、主题、口味测试等
│   └── admin/             # 管理端 7 个 store
├── views/                 # 用户端 27 页 + merchant/ 5 页 + admin/ 8 页
├── components/            # Header、FoodCard、ThemeSwitcher、TimeTimeline 等
├── composables/           # useCommunity 等组合式函数
├── utils/                 # Storage、logger、resolveAvatarUrl 等
└── constants/             # 常量(含默认头像、存储键)
```

### 3.1 路由与守卫

- 用户端:`/`、`/foods`、`/food/:id`、`/stores`、`/store/:id`、`/map`、`/community`、`/shop`、`/product/:id`、`/cart`、`/order/create|payment|success`、`/user/*`、`/taste-test`、`/time-timeline`、`/merchant-apply` 等;
- 商家端:`/merchant/{dashboard,products,content,finance,profile}`;
- 管理端:`/admin/{dashboard,users,roles,permissions,statistics,settings,merchants,content}`;
- 守卫:`meta.requiresAuth` 未登录跳 `/login`;`meta.requiresAdmin` 要求 `userStore.user.isAdmin === 1`,不满足跳 `/user`。

### 3.2 状态管理要点

- `userStore`:登录/注册流程(见下文"认证机制"),用户与 token 持久化于 localStorage;
- `cartStore / orderStore / paymentStore`:商城下单链路;
- `communityStore`:帖子数据,点赞/评论交互同步 localStorage;
- `themeStore`:light / dark / eye-care 三主题,通过 `data-theme` 属性驱动全局样式;
- `tasteTestStore / userDataStore`:口味测试结果、收藏/浏览历史,均持久化在 localStorage;
- `stores/admin/*`:对接管理端统计、用户、角色、权限、商家审核等接口。

## 4. 关键机制说明

### 4.1 认证与权限(演示实现)

- **登录**:前端 `userStore.login(phone)` → `GET /api/user/phone/{phone}` 查到即登录,查不到则 `POST /api/user` 自动注册;token 为前端生成的 `test-token-*` 字符串,仅作登录态标记。
- **身份判定**(前端规则):管理员 = 手机号 `13800138000`;商家 = 手机号 `13800138003 / 13800138005`;其余为普通用户。
- **后端 RBAC 骨架**:`PermissionInterceptor` 拦截 `/api/admin/**`,设计上通过 `@RequirePermission` 注解 + `tb_role/tb_permission/tb_user_role/tb_role_permission` 四表校验权限,身份取自请求头 `X-User-Id`。**当前版本控制器尚未标注该注解,拦截不生效**,属于预留的完整 RBAC 骨架。

### 4.2 支付(模拟)

`PaymentServiceImpl` 本地生成支付单号(`PAY + 时间戳 + UUID`),写 `tb_payment`(0 待支付 / 1 成功 / 2 失败),支付成功将关联订单置为已支付。无第三方支付 SDK 与异步回调。

### 4.3 AI 美食讲解

`AiServiceImpl` 通过 OkHttp 调用 DashScope 文本生成接口,模型 `qwen-turbo`,系统提示词要求以"非遗美食专家"身份按 **①起源历史 ②制作工艺 ③文化价值 ④传承故事** 四段输出(500 字内)。API Key 通过配置注入,支持环境变量 `DASHSCOPE_API_KEY`(见 [deployment.md](deployment.md))。

### 4.4 统计与可视化

`StatisticsController` 提供 7 类聚合:总览、用户趋势、美食品类分布、用户地域分布、活跃度、热门美食 Top、报表导出;管理端 Dashboard 与统计页用 Chart.js 渲染,导出接口返回文件字节流。

### 4.5 预留扩展(当前未启用)

| 组件 | 现状 | 说明 |
|---|---|---|
| Elasticsearch | pom 已引入 7.17.10 客户端,代码未使用 | 搜索现为 MySQL `LIKE`/条件查询;如需启用建议升级到更新的客户端并重建索引方案 |
| Redis | 自动配置已在启动类排除，配置已移除 | 可用于缓存、验证码、热点数据；pom 依赖已预留，启用时恢复配置即可 |
| RBAC 注解 | 拦截器与注解已就绪,未标注 | 补齐注解即可激活接口级权限控制 |
