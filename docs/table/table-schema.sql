-- 快速开发管理平台数据库表结构汇总文件（MySQL 8）
-- 按模块组织，包含所有表的创建语句

-- 用户模块表结构
-- ==================================================================================

-- 用户表
CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,
    avatar_url VARCHAR(255),
    display_name VARCHAR(100),
    role VARCHAR(20) NOT NULL DEFAULT 'user',
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    last_login_at DATETIME,
    login_attempts INT NOT NULL DEFAULT 0,
    locked_until DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_role CHECK (role IN ('admin', 'user', 'developer')),
    CONSTRAINT chk_status CHECK (status IN ('active', 'inactive', 'locked'))
) COMMENT='用户基本信息表';

-- 用户认证表
CREATE TABLE user_auth_tokens (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token_hash VARCHAR(255) NOT NULL,
    token_type VARCHAR(20) NOT NULL DEFAULT 'access',
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_auth_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_token_type CHECK (token_type IN ('access', 'refresh', 'reset_password'))
) COMMENT='用户认证令牌表';

-- 用户第三方认证表
CREATE TABLE user_oauth_providers (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    provider VARCHAR(20) NOT NULL,
    provider_user_id VARCHAR(100) NOT NULL,
    access_token VARCHAR(255),
    refresh_token VARCHAR(255),
    expires_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_oauth_providers_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_provider_user UNIQUE (provider, provider_user_id),
    CONSTRAINT chk_provider CHECK (provider IN ('github', 'google', 'enterprise'))
) COMMENT='用户第三方认证表';

-- 用户设置表
CREATE TABLE user_preferences (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    theme VARCHAR(20) NOT NULL DEFAULT 'light',
    language VARCHAR(10) NOT NULL DEFAULT 'zh_CN',
    notification_enabled BOOLEAN NOT NULL DEFAULT true,
    dashboard_layout JSON,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_preferences_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_theme CHECK (theme IN ('light', 'dark', 'auto')),
    CONSTRAINT chk_language CHECK (language IN ('zh_CN', 'en_US'))
) COMMENT='用户偏好设置表';

-- 用户登录历史表
CREATE TABLE user_login_history (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    login_ip VARCHAR(45),
    login_device VARCHAR(255),
    login_location VARCHAR(100),
    login_status VARCHAR(20) NOT NULL DEFAULT 'success',
    login_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_login_history_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_login_status CHECK (login_status IN ('success', 'failed', 'locked'))
) COMMENT='用户登录历史记录表';

-- 插件模块表结构
-- ==================================================================================

-- 插件表
CREATE TABLE plugins (
    id BIGINT PRIMARY KEY,
    plugin_id VARCHAR(100) NOT NULL UNIQUE,
    plugin_name VARCHAR(100) NOT NULL,
    version VARCHAR(20) NOT NULL,
    compatible_version VARCHAR(50) NOT NULL,
    developer VARCHAR(100) NOT NULL,
    developer_email VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'disabled',
    description TEXT,
    file_path VARCHAR(255) NOT NULL,
    file_size INT NOT NULL,
    download_count INT NOT NULL DEFAULT 0,
    rating DECIMAL(3,2),
    installed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_status CHECK (status IN ('enabled', 'disabled'))
) COMMENT='插件基本信息表';

-- 插件依赖表
CREATE TABLE plugin_dependencies (
    id BIGINT PRIMARY KEY,
    plugin_id BIGINT NOT NULL,
    dependency_plugin_id VARCHAR(100) NOT NULL,
    required_version VARCHAR(50) NOT NULL,
    is_optional BOOLEAN NOT NULL DEFAULT false,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_plugin_dependencies_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE
) COMMENT='插件依赖关系表';

-- 插件扩展点表
CREATE TABLE plugin_extension_points (
    id BIGINT PRIMARY KEY,
    plugin_id BIGINT NOT NULL,
    extension_point_name VARCHAR(100) NOT NULL,
    extension_point_description TEXT,
    interface_class VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_plugin_extension_points_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_extension UNIQUE (plugin_id, extension_point_name)
) COMMENT='插件扩展点表';

-- 插件配置表
CREATE TABLE plugin_configurations (
    id BIGINT PRIMARY KEY,
    plugin_id BIGINT NOT NULL,
    config_key VARCHAR(100) NOT NULL,
    config_value TEXT,
    config_type VARCHAR(20) NOT NULL DEFAULT 'string',
    is_required BOOLEAN NOT NULL DEFAULT false,
    default_value TEXT,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_plugin_configurations_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_config UNIQUE (plugin_id, config_key),
    CONSTRAINT chk_config_type CHECK (config_type IN ('string', 'number', 'boolean', 'array', 'object'))
) COMMENT='插件配置表';

-- 插件权限表
CREATE TABLE plugin_permissions (
    id BIGINT PRIMARY KEY,
    plugin_id BIGINT NOT NULL,
    permission_name VARCHAR(100) NOT NULL,
    permission_description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_plugin_permissions_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_permission UNIQUE (plugin_id, permission_name)
) COMMENT='插件权限要求表';

-- 插件安装日志表
CREATE TABLE plugin_install_logs (
    id BIGINT PRIMARY KEY,
    plugin_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    operation VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    message TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_plugin_install_logs_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT fk_plugin_install_logs_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_operation CHECK (operation IN ('install', 'update', 'enable', 'disable', 'uninstall')),
    CONSTRAINT chk_status CHECK (status IN ('success', 'failed'))
) COMMENT='插件安装操作日志表';

-- 插件评价表
CREATE TABLE plugin_ratings (
    id BIGINT PRIMARY KEY,
    plugin_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_plugin_ratings_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT fk_plugin_ratings_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_user_rating UNIQUE (plugin_id, user_id),
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5)
) COMMENT='插件用户评价表';

-- 工程模块表结构
-- ==================================================================================

-- 工程表
CREATE TABLE projects (
    id BIGINT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    project_code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    project_type VARCHAR(50) NOT NULL,
    owner_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    visibility VARCHAR(20) NOT NULL DEFAULT 'private',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_projects_owner_id FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_status CHECK (status IN ('active', 'archived', 'deleted')),
    CONSTRAINT chk_visibility CHECK (visibility IN ('private', 'public', 'team'))
) COMMENT='工程基本信息表';

-- 工程成员表
CREATE TABLE project_members (
    id BIGINT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'developer',
    joined_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_members_project_id FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_members_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_project_user UNIQUE (project_id, user_id),
    CONSTRAINT chk_role CHECK (role IN ('owner', 'admin', 'developer', 'viewer'))
) COMMENT='工程成员关联表';

-- 工程资源表
CREATE TABLE project_resources (
    id BIGINT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    resource_name VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    resource_path VARCHAR(255) NOT NULL,
    description TEXT,
    created_by BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_resources_project_id FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_resources_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT uk_project_resource_path UNIQUE (project_id, resource_path),
    CONSTRAINT chk_resource_type CHECK (resource_type IN ('file', 'directory', 'database', 'api', 'other'))
) COMMENT='工程资源表';

-- 工程插件关联表
CREATE TABLE project_plugins (
    id BIGINT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    plugin_id BIGINT NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT true,
    config_json JSON,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_plugins_project_id FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_plugins_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_project_plugin UNIQUE (project_id, plugin_id)
) COMMENT='工程插件关联表';

-- 工程活动日志表
CREATE TABLE project_activities (
    id BIGINT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    activity_data JSON,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_activities_project_id FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_activities_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) COMMENT='工程活动日志表';

-- 工程版本表
CREATE TABLE project_versions (
    id BIGINT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    version_name VARCHAR(50) NOT NULL,
    version_code VARCHAR(50) NOT NULL,
    description TEXT,
    created_by BIGINT NOT NULL,
    release_notes TEXT,
    release_date DATETIME,
    is_released BOOLEAN NOT NULL DEFAULT false,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_versions_project_id FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_versions_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT uk_project_version UNIQUE (project_id, version_code)
) COMMENT='工程版本管理表';

-- 数据统计模块表结构
-- ==================================================================================

-- 数据统计汇总表
CREATE TABLE statistics_summary (
    id BIGINT PRIMARY KEY,
    stat_date DATE NOT NULL,
    total_users INT NOT NULL DEFAULT 0,
    new_users INT NOT NULL DEFAULT 0,
    active_users INT NOT NULL DEFAULT 0,
    total_plugins INT NOT NULL DEFAULT 0,
    new_plugins INT NOT NULL DEFAULT 0,
    plugin_downloads INT NOT NULL DEFAULT 0,
    total_projects INT NOT NULL DEFAULT 0,
    new_projects INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_stat_date UNIQUE (stat_date)
) COMMENT='数据统计汇总表';

-- 用户活跃度统计表
CREATE TABLE user_activity_stats (
    id BIGINT PRIMARY KEY,
    stat_date DATE NOT NULL,
    stat_type VARCHAR(20) NOT NULL,
    active_count INT NOT NULL DEFAULT 0,
    retention_rate DECIMAL(5,2),
    avg_duration INT, -- 平均使用时长（秒）
    growth_rate DECIMAL(5,2),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_user_activity_date_type UNIQUE (stat_date, stat_type),
    CONSTRAINT chk_stat_type CHECK (stat_type IN ('daily', 'weekly', 'monthly'))
) COMMENT='用户活跃度统计表';

-- 用户地区分布统计表
CREATE TABLE user_region_stats (
    id BIGINT PRIMARY KEY,
    stat_date DATE NOT NULL,
    region_code VARCHAR(50) NOT NULL,
    region_name VARCHAR(100) NOT NULL,
    user_count INT NOT NULL DEFAULT 0,
    percentage DECIMAL(5,2) NOT NULL,
    growth_rate DECIMAL(5,2),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_user_region_date UNIQUE (stat_date, region_code)
) COMMENT='用户地区分布统计表';

-- 插件使用统计表
CREATE TABLE plugin_usage_stats (
    id BIGINT PRIMARY KEY,
    stat_date DATE NOT NULL,
    plugin_id BIGINT NOT NULL,
    install_count INT NOT NULL DEFAULT 0,
    active_count INT NOT NULL DEFAULT 0,
    avg_rating DECIMAL(3,2),
    growth_rate DECIMAL(5,2),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_plugin_usage_stats_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_date UNIQUE (stat_date, plugin_id)
) COMMENT='插件使用统计表';

-- 插件类别分布统计表
CREATE TABLE plugin_category_stats (
    id BIGINT PRIMARY KEY,
    stat_date DATE NOT NULL,
    category VARCHAR(50) NOT NULL,
    plugin_count INT NOT NULL DEFAULT 0,
    percentage DECIMAL(5,2) NOT NULL,
    growth_rate DECIMAL(5,2),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_plugin_category_date UNIQUE (stat_date, category)
) COMMENT='插件类别分布统计表';

-- 工程类型分布统计表
CREATE TABLE project_type_stats (
    id BIGINT PRIMARY KEY,
    stat_date DATE NOT NULL,
    project_type VARCHAR(50) NOT NULL,
    project_count INT NOT NULL DEFAULT 0,
    percentage DECIMAL(5,2) NOT NULL,
    growth_rate DECIMAL(5,2),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_project_type_date UNIQUE (stat_date, project_type)
) COMMENT='工程类型分布统计表';

-- 工程活动统计表
CREATE TABLE project_activity_stats (
    id BIGINT PRIMARY KEY,
    stat_date DATE NOT NULL,
    project_id BIGINT NOT NULL,
    activity_count INT NOT NULL DEFAULT 0,
    member_count INT NOT NULL DEFAULT 0,
    plugin_count INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_activity_stats_project_id FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT uk_project_activity_date UNIQUE (stat_date, project_id)
) COMMENT='工程活动统计表';

-- 数据报表配置表
CREATE TABLE statistic_report_configs (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    report_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    config_json JSON NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT false,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_statistic_report_configs_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_user_report_name UNIQUE (user_id, report_name),
    CONSTRAINT chk_report_type CHECK (report_type IN ('user', 'plugin', 'project', 'custom'))
) COMMENT='数据报表配置表';

-- 系统配置模块表结构
-- ==================================================================================

-- 系统参数配置表
CREATE TABLE system_configs (
    id BIGINT PRIMARY KEY,
    config_key VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT,
    config_type VARCHAR(20) NOT NULL DEFAULT 'string',
    description TEXT,
    is_encrypted BOOLEAN NOT NULL DEFAULT false,
    is_editable BOOLEAN NOT NULL DEFAULT true,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_config_type CHECK (config_type IN ('string', 'number', 'boolean', 'array', 'object'))
) COMMENT='系统参数配置表';

-- 系统日志表
CREATE TABLE system_logs (
    id BIGINT PRIMARY KEY,
    log_level VARCHAR(20) NOT NULL,
    log_module VARCHAR(50) NOT NULL,
    log_message TEXT NOT NULL,
    stack_trace TEXT,
    log_data JSON,
    ip_address VARCHAR(45),
    user_id BIGINT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_system_logs_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_log_level CHECK (log_level IN ('trace', 'debug', 'info', 'warn', 'error', 'fatal'))
) COMMENT='系统日志表';

-- 系统通知表
CREATE TABLE system_notifications (
    id BIGINT PRIMARY KEY,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    importance VARCHAR(20) NOT NULL DEFAULT 'normal',
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_by BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_system_notifications_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_importance CHECK (importance IN ('low', 'normal', 'high', 'critical'))
) COMMENT='系统公告通知表';

-- 用户通知表
CREATE TABLE user_notifications (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT false,
    related_id VARCHAR(100),
    related_type VARCHAR(50),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_notifications_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT='用户个人通知表';

-- 系统操作日志表
CREATE TABLE operation_logs (
    id BIGINT PRIMARY KEY,
    user_id BIGINT,
    operation_type VARCHAR(50) NOT NULL,
    operation_module VARCHAR(50) NOT NULL,
    operation_desc TEXT NOT NULL,
    ip_address VARCHAR(45),
    operation_status VARCHAR(20) NOT NULL DEFAULT 'success',
    detail_json JSON,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_operation_logs_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_operation_status CHECK (operation_status IN ('success', 'failed'))
) COMMENT='系统操作日志表';

-- 系统定时任务表
CREATE TABLE scheduled_tasks (
    id BIGINT PRIMARY KEY,
    task_name VARCHAR(100) NOT NULL UNIQUE,
    task_desc TEXT,
    cron_expression VARCHAR(100) NOT NULL,
    task_class VARCHAR(255) NOT NULL,
    task_data JSON,
    is_enabled BOOLEAN NOT NULL DEFAULT true,
    last_execution_time DATETIME,
    next_execution_time DATETIME,
    last_execution_status VARCHAR(20),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_last_execution_status CHECK (last_execution_status IS NULL OR last_execution_status IN ('success', 'failed', 'running'))
) COMMENT='系统定时任务表';

-- 系统API访问令牌表
CREATE TABLE api_tokens (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token_name VARCHAR(100) NOT NULL,
    token_hash VARCHAR(255) NOT NULL,
    permissions JSON,
    token_type VARCHAR(20) NOT NULL DEFAULT 'personal',
    expires_at DATETIME,
    last_used_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_api_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_user_token_name UNIQUE (user_id, token_name),
    CONSTRAINT chk_token_type CHECK (token_type IN ('personal', 'system', 'temporary'))
) COMMENT='系统API访问令牌表'; 