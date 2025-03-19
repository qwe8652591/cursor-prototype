-- 插件表设计
CREATE TABLE plugins (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plugin_id VARCHAR(100) NOT NULL,
    plugin_name VARCHAR(100) NOT NULL,
    version VARCHAR(20) NOT NULL,
    compatible_version VARCHAR(50) NOT NULL,
    developer VARCHAR(100) NOT NULL,
    developer_email VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'disabled',
    description TEXT,
    file_path VARCHAR(255) NOT NULL,
    file_size BIGINT UNSIGNED NOT NULL,
    download_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    rating DECIMAL(3,2),
    installed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE INDEX idx_plugin_id (plugin_id),
    INDEX idx_plugin_status (status),
    CONSTRAINT chk_status CHECK (status IN ('enabled', 'disabled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件基本信息表';

-- 插件依赖表
CREATE TABLE plugin_dependencies (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plugin_id BIGINT UNSIGNED NOT NULL,
    dependency_plugin_id VARCHAR(100) NOT NULL,
    required_version VARCHAR(50) NOT NULL,
    is_optional BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plugin_deps (plugin_id, dependency_plugin_id),
    CONSTRAINT fk_plugin_dependencies_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件依赖关系表';

-- 插件扩展点表
CREATE TABLE plugin_extension_points (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plugin_id BIGINT UNSIGNED NOT NULL,
    extension_point_name VARCHAR(100) NOT NULL,
    extension_point_description TEXT,
    interface_class VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plugin_ext (plugin_id),
    CONSTRAINT fk_plugin_extension_points_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_extension UNIQUE (plugin_id, extension_point_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件扩展点表';

-- 插件配置表
CREATE TABLE plugin_configurations (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plugin_id BIGINT UNSIGNED NOT NULL,
    config_key VARCHAR(100) NOT NULL,
    config_value TEXT,
    config_type VARCHAR(20) NOT NULL DEFAULT 'string',
    is_required BOOLEAN NOT NULL DEFAULT false,
    default_value TEXT,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plugin_config (plugin_id),
    CONSTRAINT fk_plugin_configurations_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_config UNIQUE (plugin_id, config_key),
    CONSTRAINT chk_config_type CHECK (config_type IN ('string', 'number', 'boolean', 'array', 'object'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件配置表';

-- 插件权限表
CREATE TABLE plugin_permissions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plugin_id BIGINT UNSIGNED NOT NULL,
    permission_name VARCHAR(100) NOT NULL,
    permission_description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plugin_perm (plugin_id),
    CONSTRAINT fk_plugin_permissions_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_permission UNIQUE (plugin_id, permission_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件权限要求表';

-- 插件安装日志表
CREATE TABLE plugin_install_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plugin_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    operation VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    message TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_plugin_install (plugin_id, user_id, created_at),
    CONSTRAINT fk_plugin_install_logs_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT fk_plugin_install_logs_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_operation CHECK (operation IN ('install', 'update', 'enable', 'disable', 'uninstall')),
    CONSTRAINT chk_status CHECK (status IN ('success', 'failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件安装操作日志表';

-- 插件评价表
CREATE TABLE plugin_ratings (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plugin_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plugin_rating (plugin_id, created_at),
    CONSTRAINT fk_plugin_ratings_plugin_id FOREIGN KEY (plugin_id) REFERENCES plugins(id) ON DELETE CASCADE,
    CONSTRAINT fk_plugin_ratings_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_plugin_user_rating UNIQUE (plugin_id, user_id),
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件用户评价表'; 