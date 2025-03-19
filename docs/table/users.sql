-- 用户表设计
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,
    avatar_url VARCHAR(255),
    display_name VARCHAR(100),
    role VARCHAR(20) NOT NULL DEFAULT 'user',
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    last_login_at TIMESTAMP NULL,
    login_attempts INT UNSIGNED NOT NULL DEFAULT 0,
    locked_until TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_role CHECK (role IN ('admin', 'user', 'developer')),
    CONSTRAINT chk_status CHECK (status IN ('active', 'inactive', 'locked'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户基本信息表';

-- 用户认证表
CREATE TABLE user_auth_tokens (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    token_hash VARCHAR(255) NOT NULL,
    token_type VARCHAR(20) NOT NULL DEFAULT 'access',
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_tokens (user_id, token_type),
    CONSTRAINT fk_user_auth_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_token_type CHECK (token_type IN ('access', 'refresh', 'reset_password'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户认证令牌表';

-- 用户第三方认证表
CREATE TABLE user_oauth_providers (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    provider VARCHAR(20) NOT NULL,
    provider_user_id VARCHAR(100) NOT NULL,
    access_token VARCHAR(255),
    refresh_token VARCHAR(255),
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_oauth (user_id),
    CONSTRAINT fk_user_oauth_providers_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_provider_user UNIQUE (provider, provider_user_id),
    CONSTRAINT chk_provider CHECK (provider IN ('github', 'google', 'enterprise'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户第三方认证表';

-- 用户设置表
CREATE TABLE user_preferences (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    theme VARCHAR(20) NOT NULL DEFAULT 'light',
    language VARCHAR(10) NOT NULL DEFAULT 'zh_CN',
    notification_enabled BOOLEAN NOT NULL DEFAULT true,
    dashboard_layout JSON,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_user_preferences UNIQUE (user_id),
    CONSTRAINT fk_user_preferences_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_theme CHECK (theme IN ('light', 'dark', 'auto')),
    CONSTRAINT chk_language CHECK (language IN ('zh_CN', 'en_US'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户偏好设置表';

-- 用户登录历史表
CREATE TABLE user_login_history (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    login_ip VARCHAR(45),
    login_device VARCHAR(255),
    login_location VARCHAR(100),
    login_status VARCHAR(20) NOT NULL DEFAULT 'success',
    login_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_login_history (user_id, login_time),
    CONSTRAINT fk_user_login_history_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_login_status CHECK (login_status IN ('success', 'failed', 'locked'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户登录历史记录表'; 