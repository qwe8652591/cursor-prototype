-- 快速开发管理平台数据库索引优化脚本
-- 为重要的查询字段添加索引，提高查询性能

-- 用户模块索引
-- ==================================================================================

-- 用户表索引
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at);

-- 用户认证表索引
CREATE INDEX idx_user_auth_tokens_user_id ON user_auth_tokens(user_id);
CREATE INDEX idx_user_auth_tokens_expires_at ON user_auth_tokens(expires_at);
CREATE INDEX idx_user_auth_tokens_token_type ON user_auth_tokens(token_type);

-- 用户第三方认证表索引
CREATE INDEX idx_user_oauth_providers_user_id ON user_oauth_providers(user_id);
CREATE INDEX idx_user_oauth_providers_provider ON user_oauth_providers(provider);

-- 用户登录历史表索引
CREATE INDEX idx_user_login_history_user_id ON user_login_history(user_id);
CREATE INDEX idx_user_login_history_login_time ON user_login_history(login_time);
CREATE INDEX idx_user_login_history_login_status ON user_login_history(login_status);
CREATE INDEX idx_user_login_history_login_ip ON user_login_history(login_ip);

-- 插件模块索引
-- ==================================================================================

-- 插件表索引
CREATE INDEX idx_plugins_plugin_id ON plugins(plugin_id);
CREATE INDEX idx_plugins_plugin_name ON plugins(plugin_name);
CREATE INDEX idx_plugins_status ON plugins(status);
CREATE INDEX idx_plugins_developer ON plugins(developer);
CREATE INDEX idx_plugins_installed_at ON plugins(installed_at);
CREATE INDEX idx_plugins_download_count ON plugins(download_count);
CREATE INDEX idx_plugins_rating ON plugins(rating);

-- 插件依赖表索引
CREATE INDEX idx_plugin_dependencies_plugin_id ON plugin_dependencies(plugin_id);
CREATE INDEX idx_plugin_dependencies_dependency_plugin_id ON plugin_dependencies(dependency_plugin_id);

-- 插件配置表索引
CREATE INDEX idx_plugin_configurations_plugin_id ON plugin_configurations(plugin_id);
CREATE INDEX idx_plugin_configurations_config_key ON plugin_configurations(plugin_id, config_key);

-- 插件安装日志表索引
CREATE INDEX idx_plugin_install_logs_plugin_id ON plugin_install_logs(plugin_id);
CREATE INDEX idx_plugin_install_logs_user_id ON plugin_install_logs(user_id);
CREATE INDEX idx_plugin_install_logs_operation ON plugin_install_logs(operation);
CREATE INDEX idx_plugin_install_logs_created_at ON plugin_install_logs(created_at);

-- 插件评价表索引
CREATE INDEX idx_plugin_ratings_plugin_id ON plugin_ratings(plugin_id);
CREATE INDEX idx_plugin_ratings_user_id ON plugin_ratings(user_id);
CREATE INDEX idx_plugin_ratings_rating ON plugin_ratings(rating);

-- 工程模块索引
-- ==================================================================================

-- 工程表索引
CREATE INDEX idx_projects_project_name ON projects(project_name);
CREATE INDEX idx_projects_project_code ON projects(project_code);
CREATE INDEX idx_projects_owner_id ON projects(owner_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_visibility ON projects(visibility);
CREATE INDEX idx_projects_project_type ON projects(project_type);
CREATE INDEX idx_projects_created_at ON projects(created_at);

-- 工程成员表索引
CREATE INDEX idx_project_members_project_id ON project_members(project_id);
CREATE INDEX idx_project_members_user_id ON project_members(user_id);
CREATE INDEX idx_project_members_role ON project_members(role);
CREATE INDEX idx_project_members_joined_at ON project_members(joined_at);

-- 工程资源表索引
CREATE INDEX idx_project_resources_project_id ON project_resources(project_id);
CREATE INDEX idx_project_resources_resource_type ON project_resources(resource_type);
CREATE INDEX idx_project_resources_created_by ON project_resources(created_by);

-- 工程插件关联表索引
CREATE INDEX idx_project_plugins_project_id ON project_plugins(project_id);
CREATE INDEX idx_project_plugins_plugin_id ON project_plugins(plugin_id);
CREATE INDEX idx_project_plugins_enabled ON project_plugins(enabled);

-- 工程活动日志表索引
CREATE INDEX idx_project_activities_project_id ON project_activities(project_id);
CREATE INDEX idx_project_activities_user_id ON project_activities(user_id);
CREATE INDEX idx_project_activities_activity_type ON project_activities(activity_type);
CREATE INDEX idx_project_activities_created_at ON project_activities(created_at);

-- 工程版本表索引
CREATE INDEX idx_project_versions_project_id ON project_versions(project_id);
CREATE INDEX idx_project_versions_version_code ON project_versions(version_code);
CREATE INDEX idx_project_versions_created_by ON project_versions(created_by);
CREATE INDEX idx_project_versions_is_released ON project_versions(is_released);

-- 数据统计模块索引
-- ==================================================================================

-- 数据统计汇总表索引
CREATE INDEX idx_statistics_summary_stat_date ON statistics_summary(stat_date);

-- 用户活跃度统计表索引
CREATE INDEX idx_user_activity_stats_stat_date ON user_activity_stats(stat_date);
CREATE INDEX idx_user_activity_stats_stat_type ON user_activity_stats(stat_type);
CREATE INDEX idx_user_activity_stats_date_type ON user_activity_stats(stat_date, stat_type);

-- 用户地区分布统计表索引
CREATE INDEX idx_user_region_stats_stat_date ON user_region_stats(stat_date);
CREATE INDEX idx_user_region_stats_region_code ON user_region_stats(region_code);
CREATE INDEX idx_user_region_stats_user_count ON user_region_stats(user_count DESC);

-- 插件使用统计表索引
CREATE INDEX idx_plugin_usage_stats_stat_date ON plugin_usage_stats(stat_date);
CREATE INDEX idx_plugin_usage_stats_plugin_id ON plugin_usage_stats(plugin_id);
CREATE INDEX idx_plugin_usage_stats_install_count ON plugin_usage_stats(install_count DESC);
CREATE INDEX idx_plugin_usage_stats_active_count ON plugin_usage_stats(active_count DESC);

-- 插件类别分布统计表索引
CREATE INDEX idx_plugin_category_stats_stat_date ON plugin_category_stats(stat_date);
CREATE INDEX idx_plugin_category_stats_category ON plugin_category_stats(category);
CREATE INDEX idx_plugin_category_stats_plugin_count ON plugin_category_stats(plugin_count DESC);

-- 工程类型分布统计表索引
CREATE INDEX idx_project_type_stats_stat_date ON project_type_stats(stat_date);
CREATE INDEX idx_project_type_stats_project_type ON project_type_stats(project_type);
CREATE INDEX idx_project_type_stats_project_count ON project_type_stats(project_count DESC);

-- 工程活动统计表索引
CREATE INDEX idx_project_activity_stats_stat_date ON project_activity_stats(stat_date);
CREATE INDEX idx_project_activity_stats_project_id ON project_activity_stats(project_id);
CREATE INDEX idx_project_activity_stats_activity_count ON project_activity_stats(activity_count DESC);

-- 数据报表配置表索引
CREATE INDEX idx_statistic_report_configs_user_id ON statistic_report_configs(user_id);
CREATE INDEX idx_statistic_report_configs_report_type ON statistic_report_configs(report_type);

-- 系统配置模块索引
-- ==================================================================================

-- 系统参数配置表索引
CREATE INDEX idx_system_configs_config_key ON system_configs(config_key);

-- 系统日志表索引
CREATE INDEX idx_system_logs_log_level ON system_logs(log_level);
CREATE INDEX idx_system_logs_log_module ON system_logs(log_module);
CREATE INDEX idx_system_logs_user_id ON system_logs(user_id);
CREATE INDEX idx_system_logs_created_at ON system_logs(created_at);

-- 系统通知表索引
CREATE INDEX idx_system_notifications_notification_type ON system_notifications(notification_type);
CREATE INDEX idx_system_notifications_importance ON system_notifications(importance);
CREATE INDEX idx_system_notifications_start_time ON system_notifications(start_time);
CREATE INDEX idx_system_notifications_end_time ON system_notifications(end_time);
CREATE INDEX idx_system_notifications_is_active ON system_notifications(is_active);
CREATE INDEX idx_system_notifications_created_by ON system_notifications(created_by);

-- 用户通知表索引
CREATE INDEX idx_user_notifications_user_id ON user_notifications(user_id);
CREATE INDEX idx_user_notifications_is_read ON user_notifications(is_read);
CREATE INDEX idx_user_notifications_notification_type ON user_notifications(notification_type);
CREATE INDEX idx_user_notifications_created_at ON user_notifications(created_at);
CREATE INDEX idx_user_notifications_related_id ON user_notifications(related_id);
CREATE INDEX idx_user_notifications_related_type ON user_notifications(related_type);

-- 系统操作日志表索引
CREATE INDEX idx_operation_logs_user_id ON operation_logs(user_id);
CREATE INDEX idx_operation_logs_operation_type ON operation_logs(operation_type);
CREATE INDEX idx_operation_logs_operation_module ON operation_logs(operation_module);
CREATE INDEX idx_operation_logs_operation_status ON operation_logs(operation_status);
CREATE INDEX idx_operation_logs_created_at ON operation_logs(created_at);

-- 系统定时任务表索引
CREATE INDEX idx_scheduled_tasks_is_enabled ON scheduled_tasks(is_enabled);
CREATE INDEX idx_scheduled_tasks_next_execution_time ON scheduled_tasks(next_execution_time);
CREATE INDEX idx_scheduled_tasks_last_execution_status ON scheduled_tasks(last_execution_status);

-- 系统API访问令牌表索引
CREATE INDEX idx_api_tokens_user_id ON api_tokens(user_id);
CREATE INDEX idx_api_tokens_token_type ON api_tokens(token_type);
CREATE INDEX idx_api_tokens_expires_at ON api_tokens(expires_at);
CREATE INDEX idx_api_tokens_last_used_at ON api_tokens(last_used_at); 