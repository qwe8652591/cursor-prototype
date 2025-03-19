-- 数据统计汇总表
CREATE TABLE statistics_summary (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stat_date DATE NOT NULL,
    total_users BIGINT UNSIGNED NOT NULL DEFAULT 0,
    new_users BIGINT UNSIGNED NOT NULL DEFAULT 0,
    active_users BIGINT UNSIGNED NOT NULL DEFAULT 0,
    total_plugins BIGINT UNSIGNED NOT NULL DEFAULT 0,
    new_plugins BIGINT UNSIGNED NOT NULL DEFAULT 0,
    plugin_downloads BIGINT UNSIGNED NOT NULL DEFAULT 0,
    total_projects BIGINT UNSIGNED NOT NULL DEFAULT 0,
    new_projects BIGINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_stat_date UNIQUE (stat_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据统计汇总表';

-- 用户活跃度统计表
CREATE TABLE user_activity_stats (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stat_date DATE NOT NULL,
    stat_type VARCHAR(20) NOT NULL,
    active_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    retention_rate DECIMAL(5,2),
    avg_duration INT UNSIGNED, -- 平均使用时长（秒）
    growth_rate DECIMAL(5,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_activity_date (stat_date),
    CONSTRAINT uk_user_activity_date_type UNIQUE (stat_date, stat_type),
    CONSTRAINT chk_stat_type CHECK (stat_type IN ('daily', 'weekly', 'monthly'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户活跃度统计表';

-- 用户地区分布统计表
CREATE TABLE user_region_stats (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stat_date DATE NOT NULL,
    region_code VARCHAR(50) NOT NULL,
    region_name VARCHAR(100) NOT NULL,
    user_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    percentage DECIMAL(5,2) NOT NULL,
    growth_rate DECIMAL(5,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_region_stats_date (stat_date),
    CONSTRAINT uk_user_region_date UNIQUE (stat_date, region_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户地区分布统计表';

-- 插件使用统计表
CREATE TABLE plugin_usage_stats (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stat_date DATE NOT NULL,
    plugin_id BIGINT UNSIGNED NOT NULL,
    install_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    active_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    avg_rating DECIMAL(3,2),
    growth_rate DECIMAL(5,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plugin_usage_date (stat_date),
    INDEX idx_plugin_usage_plugin (plugin_id),
    CONSTRAINT fk_plugin_usage_stats_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_date UNIQUE (stat_date, plugin_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件使用统计表';

-- 插件类别分布统计表
CREATE TABLE plugin_category_stats (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stat_date DATE NOT NULL,
    category VARCHAR(50) NOT NULL,
    plugin_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    percentage DECIMAL(5,2) NOT NULL,
    growth_rate DECIMAL(5,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category_stats_date (stat_date),
    CONSTRAINT uk_plugin_category_date UNIQUE (stat_date, category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件类别分布统计表';

-- 工程类型分布统计表
CREATE TABLE project_type_stats (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stat_date DATE NOT NULL,
    project_type VARCHAR(50) NOT NULL,
    project_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    percentage DECIMAL(5,2) NOT NULL,
    growth_rate DECIMAL(5,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_project_type_date (stat_date),
    CONSTRAINT uk_project_type_date UNIQUE (stat_date, project_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工程类型分布统计表';

-- 工程活动统计表
CREATE TABLE project_activity_stats (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stat_date DATE NOT NULL,
    project_id BIGINT UNSIGNED NOT NULL,
    activity_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    member_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    plugin_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_project_activity_date (stat_date),
    INDEX idx_project_activity_project (project_id),
    CONSTRAINT fk_project_activity_stats_project_id FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT uk_project_activity_date UNIQUE (stat_date, project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工程活动统计表';

-- 数据报表配置表
CREATE TABLE statistic_report_configs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    report_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    config_json JSON NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_report_configs_user (user_id),
    CONSTRAINT fk_statistic_report_configs_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_user_report_name UNIQUE (user_id, report_name),
    CONSTRAINT chk_report_type CHECK (report_type IN ('user', 'plugin', 'project', 'custom'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据报表配置表'; 