# 首页相关接口文档

## 版本历史

| 日期       | 版本  | 作者 | 更新内容     |
|------------|-------|------|--------------|
| 2024-06-15 | v1.0  | 莫寅 | 初始版本      |

## 接口清单

| 序号 | 接口名称 | 接口路径 | 请求方法 |
|------|---------|----------|---------|
| 1    | 获取平台信息 | /api/v1/platform/info | GET |
| 2    | 获取功能导航 | /api/v1/platform/features | GET |
| 3    | 获取首页轮播图 | /api/v1/platform/carousel | GET |
| 4    | 发送平台反馈 | /api/v1/platform/feedback | POST |

## 1. 获取平台信息接口

### 接口描述
获取平台的基本信息，包括平台名称、版本、描述等

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/platform/info

### 请求参数
无

### 请求示例
```http
GET /api/v1/platform/info HTTP/1.1
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 500    | 服务器错误 |

### 响应参数
| 参数名          | 类型    | 说明                |
|-----------------|---------|---------------------|
| code            | integer | 状态码，200表示成功 |
| msg             | string  | 状态消息            |
| data            | object  | 返回数据对象        |
| ├─ name         | string  | 平台名称            |
| ├─ version      | string  | 平台版本            |
| ├─ description  | string  | 平台描述            |
| ├─ logoUrl      | string  | Logo图片URL         |
| ├─ copyright    | string  | 版权信息            |
| └─ contactEmail | string  | 联系邮箱            |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "name": "快速开发管理平台",
    "version": "1.0.0",
    "description": "高效、便捷的插件管理与数据分析平台",
    "logoUrl": "https://example.com/assets/logo.png",
    "copyright": "© 2024 快速开发管理平台. All rights reserved.",
    "contactEmail": "support@example.com"
  }
}
```

## 2. 获取功能导航接口

### 接口描述
获取平台的功能导航信息，适用于未登录用户查看平台功能概览

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/platform/features

### 请求参数
无

### 请求示例
```http
GET /api/v1/platform/features HTTP/1.1
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 500    | 服务器错误 |

### 响应参数
| 参数名          | 类型    | 说明                |
|-----------------|---------|---------------------|
| code            | integer | 状态码，200表示成功 |
| msg             | string  | 状态消息            |
| data            | array   | 功能列表            |
| ├─ id           | string  | 功能ID              |
| ├─ name         | string  | 功能名称            |
| ├─ description  | string  | 功能描述            |
| ├─ iconUrl      | string  | 功能图标URL         |
| └─ route        | string  | 功能路由路径        |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": [
    {
      "id": "plugin-management",
      "name": "插件管理",
      "description": "便捷管理系统插件，支持上传、启用、禁用等操作",
      "iconUrl": "https://example.com/assets/icons/plugin.svg",
      "route": "/plugins"
    },
    {
      "id": "data-statistics",
      "name": "数据统计",
      "description": "多维度数据分析，帮助管理员了解系统运行状态",
      "iconUrl": "https://example.com/assets/icons/statistics.svg",
      "route": "/statistics"
    },
    {
      "id": "user-management",
      "name": "用户管理",
      "description": "管理系统用户，设置权限和角色",
      "iconUrl": "https://example.com/assets/icons/user.svg",
      "route": "/users"
    }
  ]
}
```

## 3. 获取首页轮播图接口

### 接口描述
获取首页轮播图展示内容

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/platform/carousel

### 请求参数
无

### 请求示例
```http
GET /api/v1/platform/carousel HTTP/1.1
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 500    | 服务器错误 |

### 响应参数
| 参数名          | 类型    | 说明                |
|-----------------|---------|---------------------|
| code            | integer | 状态码，200表示成功 |
| msg             | string  | 状态消息            |
| data            | array   | 轮播图列表          |
| ├─ id           | string  | 轮播图ID            |
| ├─ title        | string  | 标题                |
| ├─ description  | string  | 描述                |
| ├─ imageUrl     | string  | 图片URL             |
| ├─ linkUrl      | string  | 链接URL             |
| └─ order        | integer | 显示顺序            |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": [
    {
      "id": "carousel-001",
      "title": "欢迎使用快速开发管理平台",
      "description": "高效、便捷的插件管理与数据分析平台",
      "imageUrl": "https://example.com/assets/carousel/banner1.jpg",
      "linkUrl": "/about",
      "order": 1
    },
    {
      "id": "carousel-002",
      "title": "强大的插件生态",
      "description": "丰富多样的插件满足各类开发需求",
      "imageUrl": "https://example.com/assets/carousel/banner2.jpg",
      "linkUrl": "/plugins",
      "order": 2
    },
    {
      "id": "carousel-003",
      "title": "数据驱动决策",
      "description": "直观的数据统计分析助力决策",
      "imageUrl": "https://example.com/assets/carousel/banner3.jpg",
      "linkUrl": "/statistics",
      "order": 3
    }
  ]
}
```

## 4. 发送平台反馈接口

### 接口描述
提交对平台的意见和建议

### 请求信息
- **请求方法**：POST
- **接口URL**：/api/v1/platform/feedback
- **Content-Type**：application/json

### 请求参数
| 参数名     | 必选  | 类型    | 说明             |
|------------|-------|---------|------------------|
| name       | true  | string  | 反馈者姓名       |
| email      | true  | string  | 反馈者邮箱       |
| topic      | true  | string  | 反馈主题         |
| content    | true  | string  | 反馈内容         |
| contactMe  | false | boolean | 是否希望回复联系 |

### 请求示例
```http
POST /api/v1/platform/feedback HTTP/1.1
Content-Type: application/json

{
  "name": "张三",
  "email": "zhangsan@example.com",
  "topic": "功能建议",
  "content": "希望能够增加更多的数据可视化图表类型",
  "contactMe": true
}
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 提交成功 |
| 400    | 参数错误 |
| 429    | 请求过于频繁 |
| 500    | 服务器错误 |

### 响应参数
| 参数名  | 类型    | 说明                  |
|---------|---------|----------------------|
| code    | integer | 状态码，200表示成功   |
| msg     | string  | 状态消息              |
| data    | object  | 返回数据对象          |
| └─ id   | string  | 反馈记录ID            |

### 响应示例
```json
{
  "code": 200,
  "msg": "FEEDBACK_SUBMITTED",
  "data": {
    "id": "fb-20240611-001"
  }
}
``` 