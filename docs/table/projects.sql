-- 工程表设计
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