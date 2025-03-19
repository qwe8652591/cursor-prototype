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