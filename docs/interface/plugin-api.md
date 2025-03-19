# 插件管理相关接口文档

## 版本历史

| 日期       | 版本  | 作者 | 更新内容     |
|------------|-------|------|--------------|
| 2024-06-15 | v1.0  | 莫寅 | 初始版本      |

## 接口清单

| 序号 | 接口名称 | 接口路径 | 请求方法 |
|------|---------|----------|---------|
| 1    | 获取插件列表 | /api/v1/plugins | GET |
| 2    | 获取插件详情 | /api/v1/plugins/{pluginId} | GET |
| 3    | 上传插件 | /api/v1/plugins | POST |
| 4    | 启用/禁用插件 | /api/v1/plugins/{pluginId}/status | PATCH |
| 5    | 删除插件 | /api/v1/plugins/{pluginId} | DELETE |

## 1. 获取插件列表接口

### 接口描述
获取系统中的插件列表，支持分页、筛选和搜索

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/plugins
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                                            |
|------------|-------|---------|------------------------------------------------|
| status     | false | string  | 插件状态筛选：all(全部)/enabled(已启用)/disabled(已禁用)，默认all |
| keyword    | false | string  | 搜索关键词，搜索插件名称、ID或描述               |
| page       | false | integer | 当前页码，默认1                                 |
| pageSize   | false | integer | 每页条数，默认10                                |

### 请求示例
```http
GET /api/v1/plugins?status=enabled&keyword=数据&page=1&pageSize=10 HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
| 参数名         | 类型    | 说明                           |
|----------------|---------|--------------------------------|
| code           | integer | 状态码，200表示成功            |
| msg            | string  | 状态消息                       |
| data           | object  | 返回数据对象                   |
| ├─ total       | integer | 总记录数                       |
| ├─ pages       | integer | 总页数                         |
| ├─ current     | integer | 当前页码                       |
| ├─ size        | integer | 每页条数                       |
| ├─ records     | array   | 插件列表                       |
| │  ├─ id       | string  | 插件ID                         |
| │  ├─ name     | string  | 插件名称                       |
| │  ├─ version  | string  | 版本号                         |
| │  ├─ developer| string  | 开发者                         |
| │  ├─ email    | string  | 开发者邮箱                     |
| │  ├─ status   | string  | 状态：enabled/disabled         |
| │  ├─ installTime | string | 安装时间                      |
| │  ├─ updateTime  | string | 更新时间                      |
| │  ├─ compatibleVersion | string | 兼容版本               |
| │  └─ description | string | 插件描述                      |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "total": 24,
    "pages": 3,
    "current": 1,
    "size": 10,
    "records": [
      {
        "id": "com.company.data.analysis",
        "name": "数据分析插件",
        "version": "1.2.0",
        "developer": "数据团队",
        "email": "data@example.com",
        "status": "enabled",
        "installTime": "2024-05-10T08:30:00Z",
        "updateTime": "2024-06-01T14:15:30Z",
        "compatibleVersion": "1.0.0-2.0.0",
        "description": "提供高级数据分析和可视化功能"
      },
      {
        "id": "com.company.data.export",
        "name": "数据导出插件",
        "version": "0.9.5",
        "developer": "导出团队",
        "email": "export@example.com",
        "status": "enabled",
        "installTime": "2024-05-15T10:20:00Z",
        "updateTime": "2024-05-15T10:20:00Z",
        "compatibleVersion": "1.0.0-2.0.0",
        "description": "支持多种格式的数据导出功能"
      }
    ]
  }
}
```

## 2. 获取插件详情接口

### 接口描述
获取特定插件的详细信息

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/plugins/{pluginId}
- **Authorization**：Bearer {token}

### 请求参数
| 参数名    | 必选  | 类型   | 说明                           |
|-----------|-------|--------|--------------------------------|
| pluginId  | true  | string | 插件ID，路径参数                |

### 请求示例
```http
GET /api/v1/plugins/com.company.data.analysis HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 401    | 未认证   |
| 403    | 无权限   |
| 404    | 插件不存在 |

### 响应参数
| 参数名             | 类型    | 说明                           |
|--------------------|---------|--------------------------------|
| code               | integer | 状态码，200表示成功            |
| msg                | string  | 状态消息                       |
| data               | object  | 插件详情                       |
| ├─ id              | string  | 插件ID                         |
| ├─ name            | string  | 插件名称                       |
| ├─ version         | string  | 版本号                         |
| ├─ developer       | string  | 开发者                         |
| ├─ email           | string  | 开发者邮箱                     |
| ├─ status          | string  | 状态：enabled/disabled         |
| ├─ installTime     | string  | 安装时间                       |
| ├─ updateTime      | string  | 更新时间                       |
| ├─ compatibleVersion | string | 兼容版本                      |
| ├─ description     | string  | 插件描述                       |
| ├─ size            | integer | 插件大小，单位KB               |
| ├─ dependencies    | array   | 依赖项列表                     |
| │  ├─ id           | string  | 依赖插件ID                     |
| │  ├─ name         | string  | 依赖插件名称                   |
| │  ├─ version      | string  | 依赖版本要求                   |
| │  └─ installed    | boolean | 是否已安装                     |
| ├─ extensionPoints | array   | 扩展点列表                     |
| │  ├─ id           | string  | 扩展点ID                       |
| │  ├─ name         | string  | 扩展点名称                     |
| │  └─ description  | string  | 扩展点描述                     |
| └─ config          | object  | 插件配置信息                   |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "id": "com.company.data.analysis",
    "name": "数据分析插件",
    "version": "1.2.0",
    "developer": "数据团队",
    "email": "data@example.com",
    "status": "enabled",
    "installTime": "2024-05-10T08:30:00Z",
    "updateTime": "2024-06-01T14:15:30Z",
    "compatibleVersion": "1.0.0-2.0.0",
    "description": "提供高级数据分析和可视化功能，支持多种图表类型和数据源",
    "size": 1250,
    "dependencies": [
      {
        "id": "com.company.core",
        "name": "核心插件",
        "version": ">=1.0.0",
        "installed": true
      },
      {
        "id": "com.company.chart",
        "name": "图表插件",
        "version": ">=0.8.0",
        "installed": true
      }
    ],
    "extensionPoints": [
      {
        "id": "data.analysis.chart",
        "name": "图表分析",
        "description": "提供数据分析图表功能"
      },
      {
        "id": "data.analysis.export",
        "name": "分析导出",
        "description": "提供分析结果导出功能"
      }
    ],
    "config": {
      "maxDataPoints": 5000,
      "enableCache": true,
      "cacheExpiration": 3600,
      "supportedCharts": ["bar", "line", "pie", "scatter", "radar"]
    }
  }
}
```

## 3. 上传插件接口

### 接口描述
上传新的插件包到系统

### 请求信息
- **请求方法**：POST
- **接口URL**：/api/v1/plugins
- **Content-Type**：multipart/form-data
- **Authorization**：Bearer {token}

### 请求参数
| 参数名        | 必选  | 类型   | 说明                           |
|---------------|-------|--------|--------------------------------|
| file          | true  | file   | 插件包文件，支持.jar或.zip格式  |
| autoActivate  | false | boolean| 上传后是否自动启用，默认false   |

### 请求示例
```http
POST /api/v1/plugins HTTP/1.1
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="data-analysis-plugin-1.2.0.jar"
Content-Type: application/java-archive

(二进制文件内容)
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="autoActivate"

true
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 201    | 创建成功 |
| 400    | 请求参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |
| 409    | 插件冲突 |
| 413    | 文件过大 |
| 415    | 不支持的文件类型 |

### 响应参数
| 参数名        | 类型    | 说明                           |
|---------------|---------|--------------------------------|
| code          | integer | 状态码，201表示成功            |
| msg           | string  | 状态消息                       |
| data          | object  | 返回数据对象                   |
| ├─ id         | string  | 插件ID                         |
| ├─ name       | string  | 插件名称                       |
| ├─ version    | string  | 版本号                         |
| └─ status     | string  | 状态：enabled/disabled         |

### 响应示例
```json
{
  "code": 201,
  "msg": "PLUGIN_UPLOADED",
  "data": {
    "id": "com.company.data.analysis",
    "name": "数据分析插件",
    "version": "1.2.0",
    "status": "enabled"
  }
}
```

### 错误响应示例
```json
{
  "code": 409,
  "msg": "插件已存在，请先卸载现有版本",
  "data": null
}
```

## 4. 启用/禁用插件接口

### 接口描述
修改插件的启用状态

### 请求信息
- **请求方法**：PATCH
- **接口URL**：/api/v1/plugins/{pluginId}/status
- **Content-Type**：application/json
- **Authorization**：Bearer {token}

### 请求参数
| 参数名    | 必选  | 类型    | 说明                           |
|-----------|-------|---------|--------------------------------|
| pluginId  | true  | string  | 插件ID，路径参数                |
| status    | true  | string  | 目标状态：enabled/disabled      |

### 请求示例
```http
PATCH /api/v1/plugins/com.company.data.analysis/status HTTP/1.1
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

{
  "status": "disabled"
}
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 更新成功 |
| 400    | 参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |
| 404    | 插件不存在 |
| 409    | 状态冲突 |

### 响应参数
| 参数名  | 类型    | 说明                  |
|---------|---------|----------------------|
| code    | integer | 状态码，200表示成功   |
| msg     | string  | 状态消息              |
| data    | object  | 返回数据对象          |
| ├─ id   | string  | 插件ID               |
| └─ status | string | 更新后的状态         |

### 响应示例
```json
{
  "code": 200,
  "msg": "STATUS_UPDATED",
  "data": {
    "id": "com.company.data.analysis",
    "status": "disabled"
  }
}
```

## 5. 删除插件接口

### 接口描述
从系统中删除指定插件

### 请求信息
- **请求方法**：DELETE
- **接口URL**：/api/v1/plugins/{pluginId}
- **Authorization**：Bearer {token}

### 请求参数
| 参数名    | 必选  | 类型   | 说明                           |
|-----------|-------|--------|--------------------------------|
| pluginId  | true  | string | 插件ID，路径参数                |
| force     | false | boolean| 是否强制删除，默认false        |

### 请求示例
```http
DELETE /api/v1/plugins/com.company.data.analysis?force=true HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 删除成功 |
| 400    | 参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |
| 404    | 插件不存在 |
| 409    | 删除冲突 |

### 响应参数
| 参数名  | 类型    | 说明                  |
|---------|---------|----------------------|
| code    | integer | 状态码，200表示成功   |
| msg     | string  | 状态消息              |
| data    | null    | 无返回数据            |

### 响应示例
```json
{
  "code": 200,
  "msg": "PLUGIN_DELETED",
  "data": null
}
```

### 错误响应示例
```json
{
  "code": 409,
  "msg": "该插件被其他插件依赖，无法删除",
  "data": {
    "dependentPlugins": ["com.company.report.generator", "com.company.dashboard"]
  }
}
``` 