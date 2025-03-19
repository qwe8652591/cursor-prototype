# 登录相关接口文档

## 版本历史

| 日期       | 版本  | 作者 | 更新内容     |
|------------|-------|------|--------------|
| 2024-06-15 | v1.0  | 莫寅 | 初始版本      |

## 接口清单

| 序号 | 接口名称 | 接口路径 | 请求方法 |
|------|---------|----------|---------|
| 1    | 用户登录 | /api/v1/auth/login | POST |
| 2    | 获取验证码 | /api/v1/auth/captcha | GET |
| 3    | 退出登录 | /api/v1/auth/logout | POST |
| 4    | 刷新令牌 | /api/v1/auth/refresh-token | POST |
| 5    | 找回密码 | /api/v1/auth/forgot-password | POST |

## 1. 用户登录接口

### 接口描述
用户通过用户名/邮箱和密码进行系统登录认证

### 请求信息
- **请求方法**：POST
- **接口URL**：/api/v1/auth/login
- **Content-Type**：application/json

### 请求参数
| 参数名    | 必选  | 类型   | 说明                           |
|-----------|-------|--------|--------------------------------|
| username  | true  | string | 用户名或邮箱，长度不超过50字符  |
| password  | true  | string | 密码，使用MD5加密后的32位字符串 |
| captcha   | false | string | 验证码，当多次登录失败时必选    |
| captchaId | false | string | 验证码ID，与验证码搭配使用      |
| remember  | false | boolean| 是否记住登录，默认为false       |

### 请求示例
```http
POST /api/v1/auth/login HTTP/1.1
Content-Type: application/json

{
  "username": "admin@example.com",
  "password": "e10adc3949ba59abbe56e057f20f883e",
  "remember": true
}
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 登录成功 |
| 400    | 参数错误 |
| 401    | 认证失败 |
| 403    | 账号锁定 |
| 429    | 请求过于频繁，需要验证码 |

### 响应参数
| 参数名        | 类型    | 说明                           |
|---------------|---------|--------------------------------|
| code          | integer | 状态码，200表示成功            |
| msg           | string  | 状态消息                       |
| data          | object  | 返回数据对象                   |
| ├─ token      | string  | JWT访问令牌                    |
| ├─ expires_in | integer | 令牌有效期，单位秒             |
| ├─ user_info  | object  | 用户基础信息                   |
| │  ├─ user_id | string  | 用户ID                         |
| │  ├─ username| string  | 用户名                         |
| │  └─ avatar  | string  | 头像URL                        |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 7200,
    "user_info": {
      "user_id": "1001",
      "username": "admin",
      "avatar": "https://example.com/avatars/default.png"
    }
  }
}
```

### 错误响应示例
```json
{
  "code": 401,
  "msg": "用户名或密码错误",
  "data": null
}
```

## 2. 获取验证码接口

### 接口描述
获取图形验证码，用于登录验证

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/auth/captcha

### 请求参数
无

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 500    | 服务器错误 |

### 响应参数
| 参数名     | 类型   | 说明                         |
|------------|--------|------------------------------|
| code       | integer| 状态码，200表示成功          |
| msg        | string | 状态消息                     |
| data       | object | 返回数据对象                 |
| ├─ captchaId| string | 验证码ID，提交登录时需要携带 |
| ├─ imageBase64| string | 图片验证码的Base64编码     |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "captchaId": "7fa2bd91-c0d5-4ccc-9ba7-8a60ef4a258b",
    "imageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEU..."
  }
}
```

## 3. 退出登录接口

### 接口描述
用户退出系统，注销当前登录状态

### 请求信息
- **请求方法**：POST
- **接口URL**：/api/v1/auth/logout
- **Content-Type**：application/json
- **Authorization**：Bearer {token}

### 请求参数
无

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 退出成功 |
| 401    | 未认证   |

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
  "msg": "LOGOUT_SUCCESS",
  "data": null
}
```

## 4. 刷新令牌接口

### 接口描述
刷新访问令牌，延长用户登录状态

### 请求信息
- **请求方法**：POST
- **接口URL**：/api/v1/auth/refresh-token
- **Content-Type**：application/json
- **Authorization**：Bearer {refresh_token}

### 请求参数
无

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 刷新成功 |
| 401    | 令牌无效 |

### 响应参数
| 参数名        | 类型    | 说明                  |
|---------------|---------|----------------------|
| code          | integer | 状态码，200表示成功   |
| msg           | string  | 状态消息              |
| data          | object  | 返回数据对象          |
| ├─ token      | string  | 新的JWT访问令牌       |
| ├─ expires_in | integer | 令牌有效期，单位秒    |

### 响应示例
```json
{
  "code": 200,
  "msg": "TOKEN_REFRESHED",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 7200
  }
}
```

## 5. 找回密码接口

### 接口描述
通过邮箱验证找回密码

### 请求信息
- **请求方法**：POST
- **接口URL**：/api/v1/auth/forgot-password
- **Content-Type**：application/json

### 请求参数
| 参数名  | 必选 | 类型   | 说明                 |
|---------|------|--------|---------------------|
| email   | true | string | 用户注册的邮箱地址   |

### 请求示例
```http
POST /api/v1/auth/forgot-password HTTP/1.1
Content-Type: application/json

{
  "email": "user@example.com"
}
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 请求成功 |
| 400    | 参数错误 |
| 404    | 邮箱不存在 |

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
  "msg": "重置密码链接已发送到您的邮箱",
  "data": null
}
``` 