# 开发指南

> 面向二次开发者:工程约定、常见任务的实现路径、已知技术债与改进计划。

## 1. 本地开发工作流

1. 按照前提清单准备好 [deployment.md](deployment.md) 中的环境;
2. 后端 `mvn spring-boot:run`(或 IDE 运行 `Application`),前端 `npm run dev`;
3. 前端改动即时热更新;后端改动需重启(未引入 devtools);
4. 修改数据库结构后,同步更新 [sql/feiyi_food_platform.sql](sql/feiyi_food_platform.sql)(项目无迁移工具,SQL 文件即 schema 的唯一事实来源)。

## 2. 工程结构速查

详细模块划分见 [architecture.md](architecture.md),这里列出二次开发最常触碰的位置:

| 想改什么 | 去哪里 |
|---|---|
| 新增/修改接口 | 后端 `api/XxxController` + `service/impl/XxxServiceImpl`(+ 必要时 `dao`、`resources/mapper/*.xml`) |
| 新增表 | `sql/feiyi_food_platform.sql` + `model/` 实体 + `dao/` Mapper;商家域表可挂到 `MerchantSchemaInitializer` 自动建表 |
| 新增用户端页面 | `views/` 新建 `.vue` + `router/index.ts` 注册路由(需要登录则加 `meta: { requiresAuth: true }`) |
| 新增管理端页面 | `views/admin/` + `AdminLayout` 子路由 + `stores/admin/` 对应 store |
| 调整主题样式 | `themeStore`(light/dark/eye-care)+ 各组件中 `data-theme` 相关样式 |
| 前端请求封装 | `api/index.ts`(Axios 实例,响应拦截器已剥壳返回 `data`)+ 各领域 API 模块 |

## 3. 约定与注意事项

### 3.1 后端

- **响应结构**:项目未使用统一 `Result<T>` 包装——Controller 直接返回实体 / `Page` / `Map`。新代码建议保持现状或一次性统一,不要混搭第三种风格。
- **异常**:`GlobalExceptionHandler` 兜底所有异常返回 500 JSON;业务错误目前也走异常通道,前端按 HTTP 状态判断。
- **实体映射**:MyBatis-Plus 注解驱动,驼峰自动映射;交易域实体对应 `created_at` 系列字段,其余对应 `create_time` 系列(见 [database.md §4](database.md))。
- **分页**:使用 MyBatis-Plus 分页插件,Controller 手动接 `page/size` 参数;注意美食列表参数名为 `heritage_level`(下划线)。

### 3.2 前端

- **TypeScript**:工程为 TS,但部分历史代码类型标注较松(`any`),新代码建议补全类型;
- **请求**:`api/index.ts` 的响应拦截器返回 `response.data`,因此 `await api.get(...)` 拿到的直接是业务数据,不要再 `.data`;
- **图片路径**:统一用 `src/utils/index.ts` 的 `resolveAvatarUrl()` 解析,兼容 `http(s)://`、`/uploads/`、`/file/`、`/images/` 前缀与裸文件名四种形态,**不要在前端代码里硬编码后端主机地址**;
- **登录态**:`userStore` + localStorage;路由守卫用 `meta.requiresAuth` / `meta.requiresAdmin`。

## 4. 常见任务示例

### 4.1 新增一个后端接口

```java
// api/AnnouncementController.java
@RestController
@RequestMapping("/api/announcement")
public class AnnouncementController {
    @Autowired
    private AnnouncementService announcementService;

    @GetMapping("/list")
    public List<Announcement> list() {
        return announcementService.list();
    }
}
```

实体为普通 POJO + MyBatis-Plus 注解(参考 `model/Food`),Mapper 继承 `BaseMapper<Announcement>`,即可获得 MyBatis-Plus 的 CRUD 能力。

### 4.2 激活接口级权限(预留能力)

后端已有完整 RBAC 骨架,给管理端接口加注解即可启用拦截:

```java
@PutMapping("/status")
@RequirePermission(value = "商家管理", permissionKey = "admin:merchant:audit")
public ... review(...) { ... }
```

注意 `PermissionInterceptor` 需要从请求头 `X-User-Id` 获取身份,前端需在 axios 请求拦截器中带上该头。

## 5. 已知技术债与改进计划

按优先级排序,供后续迭代参考:

| 优先级 | 事项 | 说明 |
|---|---|---|
| 🔴 高 | 真实登录鉴权 | 后端补登录/登出接口 + 密码校验(BCrypt)+ JWT;前端替换 `test-token` 与"手机号即身份"规则;`tb_user.password` 已有字段 |
| 🔴 高 | 接口鉴权落地 | 为 `/api/admin/**` 标注 `@RequirePermission`,前端携带用户身份头 |
| 🟡 中 | 统一响应与错误码 | 引入 `Result<T>`(code/message/data),改造前端判断逻辑 |
| 🟡 中 | 接入真实支付 | 以微信/支付宝沙箱替换 `PaymentServiceImpl` 的本地状态机 |
| 🟡 中 | 密码等敏感字段加密存储 | 当前 `tb_user.password` 为明文演示值 |
| 🟢 低 | 启用或移除 ES / Redis 依赖 | 二选一:启用(引入 elasticsearch-java 新客户端、RedisTemplate)或从 pom 移除,避免"幽灵依赖" |
| 🟢 低 | 补充单元测试 | `src/test` 目前基本为空;建议优先覆盖 Service 层(订单、支付、商家审核状态机) |
| 🟢 低 | 时间字段命名统一 | `created_at` vs `create_time`(见 database.md) |
| 🟢 低 | CI 与代码质量工具 | GitHub Actions + Checkstyle / ESLint,`npm run build` 中加入 `vue-tsc` 类型检查 |
