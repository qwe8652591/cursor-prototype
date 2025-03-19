# 控制台相关接口文档

## 版本历史

| 日期       | 版本  | 作者 | 更新内容     |
|------------|-------|------|--------------|
| 2024-06-15 | v1.0  | 莫寅 | 初始版本      |

## 接口清单

| 序号 | 接口名称 | 接口路径 | 请求方法 |
|------|---------|----------|---------|
| 1    | 获取控制台概览数据 | /api/v1/dashboard/overview | GET |
| 2    | 获取快捷功能导航 | /api/v1/dashboard/shortcuts | GET |
| 3    | 更新快捷功能顺序 | /api/v1/dashboard/shortcuts | PUT |
| 4    | 获取通知列表 | /api/v1/dashboard/notifications | GET |
| 5    | 标记通知已读 | /api/v1/dashboard/notifications/read-status | PATCH |

## 1. 获取控制台概览数据接口

### 接口描述
获取控制台页面的概览数据，包括个性化的欢迎信息和系统状态

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/dashboard/overview
- **Authorization**：Bearer {token}

### 请求参数
无

### 请求示例
```http
GET /api/v1/dashboard/overview HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
| 参数名                 | 类型    | 说明                     |
|------------------------|---------|--------------------------|
| code                   | integer | 状态码，200表示成功      |
| msg                    | string  | 状态消息                 |
| data                   | object  | 返回数据对象             |
| ├─ userInfo            | object  | 用户信息                 |
| │  ├─ name             | string  | 用户名称                 |
| │  ├─ avatar           | string  | 头像URL                  |
| │  ├─ lastLoginTime    | string  | 上次登录时间             |
| │  └─ lastLoginIp      | string  | 上次登录IP               |
| ├─ systemStatus        | object  | 系统状态                 |
| │  ├─ version          | string  | 系统版本                 |
| │  ├─ uptime           | string  | 系统运行时间             |
| │  ├─ serverLoad       | number  | 服务器负载               |
| │  └─ memoryUsage      | number  | 内存使用率，百分比       |
| ├─ notifications       | array   | 通知列表                 |
| │  ├─ id               | string  | 通知ID                   |
| │  ├─ type             | string  | 通知类型                 |
| │  ├─ title            | string  | 通知标题                 |
| │  ├─ content          | string  | 通知内容                 |
| │  ├─ time             | string  | 通知时间                 |
| │  └─ read             | boolean | 是否已读                 |
| └─ quickStats          | object  | 快速统计数据             |
| &nbsp;&nbsp; ├─ plugins| integer | 插件数量                 |
| &nbsp;&nbsp; ├─ users  | integer | 用户数量                 |
| &nbsp;&nbsp; ├─ projects | integer | 工程数量               |
| &nbsp;&nbsp; └─ todayActiveUsers | integer | 今日活跃用户数 |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "userInfo": {
      "name": "管理员",
      "avatar": "https://example.com/avatars/admin.png",
      "lastLoginTime": "2024-06-10T15:30:00Z",
      "lastLoginIp": "192.168.1.1"
    },
    "systemStatus": {
      "version": "1.0.0",
      "uptime": "10天5小时",
      "serverLoad": 23.5,
      "memoryUsage": 65.2
    },
    "notifications": [
      {
        "id": "notification-001",
        "type": "system",
        "title": "系统更新",
        "content": "系统将于今晚22:00进行例行维护",
        "time": "2024-06-11T08:00:00Z",
        "read": false
      },
      {
        "id": "notification-002",
        "type": "plugin",
        "title": "插件更新",
        "content": "数据分析插件已更新到1.2.1版本",
        "time": "2024-06-10T14:30:00Z",
        "read": true
      }
    ],
    "quickStats": {
      "plugins": 75,
      "users": 1250,
      "projects": 328,
      "todayActiveUsers": 320
    }
  }
}
```

## 2. 获取快捷功能导航接口

### 接口描述
获取用户控制台的快捷功能导航

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/dashboard/shortcuts
- **Authorization**：Bearer {token}

### 请求参数
无

### 请求示例
```http
GET /api/v1/dashboard/shortcuts HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
| 参数名          | 类型    | 说明                |
|-----------------|---------|---------------------|
| code            | integer | 状态码，200表示成功 |
| msg             | string  | 状态消息            |
| data            | array   | 快捷功能列表        |
| ├─ id           | string  | 功能ID              |
| ├─ name         | string  | 功能名称            |
| ├─ description  | string  | 功能描述            |
| ├─ icon         | string  | 图标标识            |
| ├─ route        | string  | 路由路径            |
| ├─ order        | integer | 显示顺序            |
| └─ favorite     | boolean | 是否收藏            |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": [
    {
      "id": "plugin-management",
      "name": "插件管理",
      "description": "管理系统插件",
      "icon": "puzzle-piece",
      "route": "/plugins",
      "order": 1,
      "favorite": true
    },
    {
      "id": "data-statistics",
      "name": "数据统计",
      "description": "查看系统数据统计",
      "icon": "chart-bar",
      "route": "/statistics",
      "order": 2,
      "favorite": true
    },
    {
      "id": "profile-settings",
      "name": "个人设置",
      "description": "修改个人账户设置",
      "icon": "user-cog",
      "route": "/profile",
      "order": 3,
      "favorite": false
    }
  ]
}
```

## 3. 更新快捷功能顺序接口

### 接口描述
更新用户控制台快捷功能的显示顺序或收藏状态

### 请求信息
- **请求方法**：PUT
- **接口URL**：/api/v1/dashboard/shortcuts
- **Content-Type**：application/json
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明             |
|------------|-------|---------|------------------|
| shortcuts  | true  | array   | 快捷功能顺序列表 |
| ├─ id      | true  | string  | 功能ID           |
| ├─ order   | true  | integer | 显示顺序         |
| └─ favorite| true  | boolean | 是否收藏         |

### 请求示例
```http
PUT /api/v1/dashboard/shortcuts HTTP/1.1
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

{
  "shortcuts": [
    {
      "id": "plugin-management",
      "order": 2,
      "favorite": true
    },
    {
      "id": "data-statistics",
      "order": 1,
      "favorite": true
    },
    {
      "id": "profile-settings",
      "order": 3,
      "favorite": true
    }
  ]
}
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 更新成功 |
| 400    | 参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |

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
  "msg": "SHORTCUTS_UPDATED",
  "data": null
}
```

## 4. 获取通知列表接口

### 接口描述
获取用户的通知消息列表

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/dashboard/notifications
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                         |
|------------|-------|---------|------------------------------|
| page       | false | integer | 当前页码，默认1              |
| pageSize   | false | integer | 每页条数，默认10             |
| read       | false | boolean | 筛选已读/未读，不传则查询全部 |
| type       | false | string  | 通知类型筛选                 |

### 请求示例
```http
GET /api/v1/dashboard/notifications?page=1&pageSize=10&read=false HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 400    | 参数错误 |
| 401    | 未认证   |

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
| ├─ unread      | integer | 未读消息数                     |
| └─ records     | array   | 通知列表                       |
| &nbsp;&nbsp; ├─ id      | string  | 通知ID               |
| &nbsp;&nbsp; ├─ type    | string  | 通知类型             |
| &nbsp;&nbsp; ├─ title   | string  | 通知标题             |
| &nbsp;&nbsp; ├─ content | string  | 通知内容             |
| &nbsp;&nbsp; ├─ time    | string  | 通知时间             |
| &nbsp;&nbsp; └─ read    | boolean | 是否已读             |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "total": 25,
    "pages": 3,
    "current": 1,
    "size": 10,
    "unread": 8,
    "records": [
      {
        "id": "notification-001",
        "type": "system",
        "title": "系统更新",
        "content": "系统将于今晚22:00进行例行维护",
        "time": "2024-06-11T08:00:00Z",
        "read": false
      },
      {
        "id": "notification-002",
        "type": "plugin",
        "title": "插件更新",
        "content": "数据分析插件已更新到1.2.1版本",
        "time": "2024-06-10T14:30:00Z",
        "read": false
      }
    ]
  }
}
```

## 5. 标记通知已读接口

### 接口描述
标记用户的通知消息为已读状态

### 请求信息
- **请求方法**：PATCH
- **接口URL**：/api/v1/dashboard/notifications/read-status
- **Content-Type**：application/json
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                          |
|------------|-------|---------|------------------------------|
| ids        | false | array   | 通知ID列表，不传则标记所有为已读 |
| read       | true  | boolean | 设置的已读状态，通常为true    |

### 请求示例
```http
PATCH /api/v1/dashboard/notifications/read-status HTTP/1.1
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

{
  "ids": ["notification-001", "notification-002"],
  "read": true
}
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 更新成功 |
| 400    | 参数错误 |
| 401    | 未认证   |

### 响应参数
| 参数名            | 类型    | 说明                  |
|-------------------|---------|----------------------|
| code              | integer | 状态码，200表示成功   |
| msg               | string  | 状态消息              |
| data              | object  | 返回数据对象          |
| └─ updatedCount   | integer | 更新的记录数          |

### 响应示例
```json
{
  "code": 200,
  "msg": "NOTIFICATIONS_UPDATED",
  "data": {
    "updatedCount": 2
  }
}
``` 