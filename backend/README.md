# backend · 后端服务

「华韵味脉」非遗美食平台的 Spring Boot 后端(单体,端口 8088)。

- 技术栈:Spring Boot 2.7.15 / Java 21 / MyBatis-Plus 3.5.5 / MySQL 8.0 / DashScope(通义千问)
- 结构:`api`(17 个 Controller)→ `service` → `dao`(MyBatis-Plus),横切组件位于 `config` 与 `interceptor`
- 启动:`mvn spring-boot:run`(需先初始化数据库,见根目录 [docs/deployment.md](../docs/deployment.md))
- 配置:`src/main/resources/application.yml`(主配置,支持环境变量覆盖)+ `application-local.yml`(本地私密配置,不入库,模板见 `application-local.yml.example`)

详细文档:

| 主题 | 文档 |
|---|---|
| 系统架构与模块设计 | [docs/architecture.md](../docs/architecture.md) |
| REST API 清单 | [docs/api.md](../docs/api.md) |
| 数据库设计 | [docs/database.md](../docs/database.md) |
| 改进计划 | [docs/development.md](../docs/development.md) |
