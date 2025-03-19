# 快速开发管理平台数据库设计

此目录包含快速开发管理平台的数据库表结构设计，已完全兼容MySQL 8。

## 表结构概述

数据库设计分为以下几个核心模块：

- **用户模块**：管理用户信息、认证、权限和偏好设置
- **插件模块**：管理平台插件的注册、配置和依赖关系
- **工程模块**：管理开发项目及其资源
- **统计模块**：记录和分析各类使用数据
- **系统模块**：管理平台配置、日志和系统维护

## 文件说明

- `users.sql` - 用户相关表结构
- `plugins.sql` - 插件相关表结构
- `projects.sql` - 工程相关表结构
- `statistics.sql` - 数据统计相关表结构
- `system.sql` - 系统配置相关表结构
- `table-schema.sql` - 完整的表结构创建脚本
- `indexes.sql` - 索引优化脚本

## 数据库设计规范

1. **命名规范**：
   - 表名使用小写字母和下划线命名法（snake_case）
   - 主键统一命名为 `id`
   - 外键命名格式为 `fk_表名_字段名`
   - 唯一索引命名格式为 `uk_表名_字段名`或`uk_字段组合描述`
   - 普通索引命名格式为 `idx_表名_字段名`

2. **字段规范**：
   - 所有表均包含 `created_at` 和 `updated_at` 字段，记录行创建和更新时间
   - 使用 `DATETIME` 类型存储时间
   - 使用强类型定义，避免使用通用类型
   - 表主键使用 `BIGINT` 类型，为使用雪花算法做准备
   - 复杂数据结构使用 `JSON` 类型存储

3. **关系规范**：
   - 使用外键约束保证数据完整性
   - 合理设置级联删除（CASCADE）和限制（RESTRICT）规则
   - 使用表注释（COMMENT）说明表的用途

## 模块详细说明

### 用户模块

用户模块包含以下主要表：

- `users` - 存储用户的基本信息，如用户名、密码哈希等
- `user_auth_tokens` - 管理用户的认证令牌
- `user_oauth_providers` - 管理第三方登录信息
- `user_preferences` - 存储用户偏好设置
- `user_login_history` - 记录用户登录历史

主要关系：
- 用户表为核心，其他用户相关表通过外键关联到用户表

### 插件模块

插件模块包含以下主要表：

- `plugins` - 存储插件的基本信息
- `plugin_dependencies` - 管理插件之间的依赖关系
- `plugin_extension_points` - 定义插件提供的扩展点
- `plugin_configurations` - 存储插件配置选项
- `plugin_permissions` - 记录插件需要的权限
- `plugin_install_logs` - 记录插件安装、更新等操作日志
- `plugin_ratings` - 存储用户对插件的评价

主要关系：
- 插件表为核心，其他插件相关表通过外键关联到插件表
- 依赖关系通过 `plugin_dependencies` 表实现

### 工程模块

工程模块包含以下主要表：

- `projects` - 存储工程的基本信息
- `project_members` - 管理工程成员关系
- `project_resources` - 管理工程的资源
- `project_plugins` - 管理工程使用的插件
- `project_activities` - 记录工程活动日志
- `project_versions` - 管理工程版本

主要关系：
- 工程表为核心，其他工程相关表通过外键关联到工程表
- 工程成员通过 `project_members` 表关联用户
- 工程插件通过 `project_plugins` 表关联插件

### 统计模块

统计模块包含以下主要表：

- `statistics_summary` - 存储总体统计数据
- `user_activity_stats` - 记录用户活跃度相关统计
- `user_region_stats` - 记录用户地区分布统计
- `plugin_usage_stats` - 记录插件使用情况统计
- `plugin_category_stats` - 记录插件类别分布统计
- `project_type_stats` - 记录工程类型分布统计
- `project_activity_stats` - 记录工程活动统计
- `statistic_report_configs` - 存储自定义报表配置

主要关系：
- 统计表主要基于日期组织数据
- 插件使用统计和工程活动统计分别关联到插件表和工程表

### 系统模块

系统模块包含以下主要表：

- `system_configs` - 存储系统配置参数
- `system_logs` - 记录系统日志
- `system_notifications` - 管理系统公告
- `user_notifications` - 管理用户通知
- `operation_logs` - 记录操作日志
- `scheduled_tasks` - 管理计划任务
- `api_tokens` - 管理API访问令牌

主要关系：
- 系统日志和操作日志可选关联到用户
- 用户通知必须关联到用户

## 性能优化

为了提高查询性能，`indexes.sql`文件包含了各表的索引创建语句，主要包括：

- 主键索引（自动创建）
- 外键索引（大部分数据库会自动创建）
- 唯一索引（确保数据唯一性）
- 普通索引（提高查询性能）

主要索引策略：
- 为常用查询条件创建索引
- 为排序和分组字段创建索引
- 为统计查询的时间范围字段创建索引

## MySQL 8特性使用

数据库设计利用了MySQL 8的以下特性：

- JSON数据类型支持复杂数据结构
- 表注释功能（COMMENT）增强文档可读性
- CHECK约束确保数据完整性
- 自动更新的时间戳（ON UPDATE CURRENT_TIMESTAMP） 