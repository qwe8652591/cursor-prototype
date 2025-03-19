# 数据统计相关接口文档

## 版本历史

| 日期       | 版本  | 作者 | 更新内容     |
|------------|-------|------|--------------|
| 2024-06-15 | v1.0  | 莫寅 | 初始版本      |

## 接口清单

| 序号 | 接口名称 | 接口路径 | 请求方法 |
|------|---------|----------|---------|
| 1    | 获取数据概览 | /api/v1/statistics/overview | GET |
| 2    | 获取用户活跃度数据 | /api/v1/statistics/user-activity | GET |
| 3    | 获取用户地区分布 | /api/v1/statistics/user-distribution | GET |
| 4    | 获取插件使用统计 | /api/v1/statistics/plugin-usage | GET |
| 5    | 导出统计数据 | /api/v1/statistics/export | GET |
| 6    | 自定义报表 | /api/v1/statistics/custom-report | POST |

## 1. 获取数据概览接口

### 接口描述
获取系统关键指标数据的概览信息，包括用户数、工程数、插件数和下载量等

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/statistics/overview
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                                |
|------------|-------|---------|-------------------------------------|
| timeRange  | false | string  | 时间范围：today/week/month/year，默认month |

### 请求示例
```http
GET /api/v1/statistics/overview?timeRange=month HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
| 参数名                 | 类型    | 说明                        |
|------------------------|---------|----------------------------|
| code                   | integer | 状态码，200表示成功         |
| msg                    | string  | 状态消息                    |
| data                   | object  | 返回数据对象                |
| ├─ totalUsers          | integer | 总用户数                    |
| ├─ userGrowthRate      | number  | 用户增长率，百分比           |
| ├─ totalProjects       | integer | 总工程数                    |
| ├─ projectGrowthRate   | number  | 工程增长率，百分比           |
| ├─ totalPlugins        | integer | 总插件数                    |
| ├─ pluginGrowthRate    | number  | 插件增长率，百分比           |
| ├─ totalDownloads      | integer | 插件总下载量                |
| ├─ downloadGrowthRate  | number  | 下载量增长率，百分比         |
| └─ period              | string  | 数据统计周期                |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "totalUsers": 1250,
    "userGrowthRate": 5.8,
    "totalProjects": 328,
    "projectGrowthRate": 12.3,
    "totalPlugins": 75,
    "pluginGrowthRate": 8.2,
    "totalDownloads": 4590,
    "downloadGrowthRate": 15.6,
    "period": "2024-05-01 至 2024-05-31"
  }
}
```

## 2. 获取用户活跃度数据接口

### 接口描述
获取用户活跃度相关数据，包括日活、周活、月活用户数及趋势

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/statistics/user-activity
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                                 |
|------------|-------|---------|--------------------------------------|
| timeRange  | false | string  | 时间范围：today/week/month/year，默认month |
| dimension  | false | string  | 数据维度：day/week/month，默认day    |

### 请求示例
```http
GET /api/v1/statistics/user-activity?timeRange=month&dimension=day HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 400    | 参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
| 参数名                 | 类型    | 说明                           |
|------------------------|---------|--------------------------------|
| code                   | integer | 状态码，200表示成功            |
| msg                    | string  | 状态消息                       |
| data                   | object  | 返回数据对象                   |
| ├─ dailyActiveUsers    | integer | 日活跃用户数(DAU)              |
| ├─ dauGrowthRate       | number  | DAU环比增长率，百分比           |
| ├─ weeklyActiveUsers   | integer | 周活跃用户数(WAU)              |
| ├─ wauGrowthRate       | number  | WAU环比增长率，百分比           |
| ├─ monthlyActiveUsers  | integer | 月活跃用户数(MAU)              |
| ├─ mauGrowthRate       | number  | MAU环比增长率，百分比           |
| ├─ retentionRate       | number  | 用户留存率，百分比              |
| ├─ avgSessionDuration  | number  | 平均使用时长，单位分钟          |
| ├─ trend               | array   | 趋势数据数组                   |
| │  ├─ date             | string  | 日期                           |
| │  ├─ dau              | integer | 当日DAU                        |
| │  ├─ wau              | integer | 当日WAU                        |
| │  └─ mau              | integer | 当日MAU                        |
| └─ period              | string  | 数据统计周期                    |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "dailyActiveUsers": 320,
    "dauGrowthRate": 3.2,
    "weeklyActiveUsers": 850,
    "wauGrowthRate": 5.5,
    "monthlyActiveUsers": 1100,
    "mauGrowthRate": 7.8,
    "retentionRate": 65.3,
    "avgSessionDuration": 22.5,
    "trend": [
      {
        "date": "2024-05-01",
        "dau": 310,
        "wau": 820,
        "mau": 1050
      },
      {
        "date": "2024-05-02",
        "dau": 325,
        "wau": 830,
        "mau": 1060
      },
      {
        "date": "2024-05-03",
        "dau": 315,
        "wau": 825,
        "mau": 1065
      }
    ],
    "period": "2024-05-01 至 2024-05-31"
  }
}
```

## 3. 获取用户地区分布接口

### 接口描述
获取用户的地理位置分布数据

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/statistics/user-distribution
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                                 |
|------------|-------|---------|--------------------------------------|
| level      | false | string  | 地区级别：country/province/city，默认country |

### 请求示例
```http
GET /api/v1/statistics/user-distribution?level=province HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 400    | 参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
| 参数名                 | 类型    | 说明                           |
|------------------------|---------|--------------------------------|
| code                   | integer | 状态码，200表示成功            |
| msg                    | string  | 状态消息                       |
| data                   | object  | 返回数据对象                   |
| ├─ level               | string  | 地区级别                       |
| ├─ total               | integer | 总用户数                       |
| └─ regions             | array   | 地区分布数组                   |
| &nbsp;&nbsp; ├─ name   | string  | 地区名称                       |
| &nbsp;&nbsp; ├─ count  | integer | 用户数量                       |
| &nbsp;&nbsp; ├─ percentage | number | 占比百分比                  |
| &nbsp;&nbsp; └─ growth | number  | 环比增长率，百分比             |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "level": "province",
    "total": 1250,
    "regions": [
      {
        "name": "广东省",
        "count": 320,
        "percentage": 25.6,
        "growth": 6.2
      },
      {
        "name": "北京市",
        "count": 285,
        "percentage": 22.8,
        "growth": 4.8
      },
      {
        "name": "上海市",
        "count": 210,
        "percentage": 16.8,
        "growth": 5.5
      },
      {
        "name": "浙江省",
        "count": 150,
        "percentage": 12.0,
        "growth": 7.3
      },
      {
        "name": "其他",
        "count": 285,
        "percentage": 22.8,
        "growth": 3.2
      }
    ]
  }
}
```

## 4. 获取插件使用统计接口

### 接口描述
获取插件的使用统计数据，包括安装次数、活跃实例数等

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/statistics/plugin-usage
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                                      |
|------------|-------|---------|-------------------------------------------|
| timeRange  | false | string  | 时间范围：week/month/quarter/year，默认month |
| sort       | false | string  | 排序方式：installs/active/rating，默认installs |
| limit      | false | integer | 返回数量限制，默认10                       |

### 请求示例
```http
GET /api/v1/statistics/plugin-usage?timeRange=month&sort=installs&limit=5 HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 400    | 参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
| 参数名                  | 类型    | 说明                         |
|-------------------------|---------|------------------------------|
| code                    | integer | 状态码，200表示成功          |
| msg                     | string  | 状态消息                     |
| data                    | object  | 返回数据对象                 |
| ├─ totalInstalls        | integer | 总安装次数                   |
| ├─ totalActiveInstances | integer | 总活跃实例数                 |
| ├─ avgRating            | number  | 平均评分(1-5)                |
| ├─ period               | string  | 数据统计周期                 |
| └─ plugins              | array   | 插件统计数组                 |
| &nbsp;&nbsp; ├─ id      | string  | 插件ID                       |
| &nbsp;&nbsp; ├─ name    | string  | 插件名称                     |
| &nbsp;&nbsp; ├─ installs| integer | 安装次数                     |
| &nbsp;&nbsp; ├─ active  | integer | 活跃实例数                   |
| &nbsp;&nbsp; ├─ rating  | number  | 平均评分(1-5)                |
| &nbsp;&nbsp; └─ versions| array   | 版本分布数组                 |
| &nbsp;&nbsp;&nbsp;&nbsp; ├─ version | string | 版本号          |
| &nbsp;&nbsp;&nbsp;&nbsp; └─ percentage | number | 使用占比     |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "totalInstalls": 8750,
    "totalActiveInstances": 6250,
    "avgRating": 4.2,
    "period": "2024-05-01 至 2024-05-31",
    "plugins": [
      {
        "id": "com.company.data.analysis",
        "name": "数据分析插件",
        "installs": 1250,
        "active": 980,
        "rating": 4.7,
        "versions": [
          {
            "version": "1.2.0",
            "percentage": 65.3
          },
          {
            "version": "1.1.0",
            "percentage": 28.5
          },
          {
            "version": "1.0.0",
            "percentage": 6.2
          }
        ]
      },
      {
        "id": "com.company.code.generator",
        "name": "代码生成器",
        "installs": 980,
        "active": 845,
        "rating": 4.5,
        "versions": [
          {
            "version": "2.0.1",
            "percentage": 72.8
          },
          {
            "version": "1.9.0",
            "percentage": 27.2
          }
        ]
      },
      {
        "id": "com.company.ui.designer",
        "name": "UI设计器",
        "installs": 780,
        "active": 650,
        "rating": 4.3,
        "versions": [
          {
            "version": "3.2.1",
            "percentage": 85.4
          },
          {
            "version": "3.1.0",
            "percentage": 14.6
          }
        ]
      }
    ]
  }
}
```

## 5. 导出统计数据接口

### 接口描述
导出统计数据为Excel或CSV格式文件

### 请求信息
- **请求方法**：GET
- **接口URL**：/api/v1/statistics/export
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                                         |
|------------|-------|---------|----------------------------------------------|
| dataType   | true  | string  | 数据类型：overview/user/plugin/all           |
| format     | false | string  | 导出格式：excel/csv，默认excel               |
| timeRange  | false | string  | 时间范围：month/quarter/year，默认month      |

### 请求示例
```http
GET /api/v1/statistics/export?dataType=user&format=excel&timeRange=month HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 导出成功 |
| 400    | 参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
二进制文件流，附带以下header：
- Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet（Excel）或 text/csv（CSV）
- Content-Disposition: attachment; filename="statistics-user-2024-05.xlsx"

## 6. 自定义报表接口

### 接口描述
获取自定义配置的统计报表数据

### 请求信息
- **请求方法**：POST
- **接口URL**：/api/v1/statistics/custom-report
- **Content-Type**：application/json
- **Authorization**：Bearer {token}

### 请求参数
| 参数名     | 必选  | 类型    | 说明                                   |
|------------|-------|---------|----------------------------------------|
| metrics    | true  | array   | 需要统计的指标数组                     |
| timeRange  | true  | object  | 时间范围                               |
| ├─ start   | true  | string  | 开始日期，格式：YYYY-MM-DD            |
| └─ end     | true  | string  | 结束日期，格式：YYYY-MM-DD            |
| dimension  | false | string  | 数据维度：day/week/month，默认day      |
| filters    | false | array   | 数据筛选条件                           |

### 请求示例
```http
POST /api/v1/statistics/custom-report HTTP/1.1
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

{
  "metrics": ["dau", "newUsers", "pluginInstalls"],
  "timeRange": {
    "start": "2024-05-01",
    "end": "2024-05-31"
  },
  "dimension": "day",
  "filters": [
    {
      "field": "userType",
      "operator": "eq",
      "value": "developer"
    }
  ]
}
```

### 响应信息
| 状态码 | 说明     |
|--------|----------|
| 200    | 获取成功 |
| 400    | 参数错误 |
| 401    | 未认证   |
| 403    | 无权限   |

### 响应参数
| 参数名             | 类型    | 说明                       |
|--------------------|---------|----------------------------|
| code               | integer | 状态码，200表示成功        |
| msg                | string  | 状态消息                   |
| data               | object  | 返回数据对象               |
| ├─ period          | string  | 数据统计周期               |
| ├─ dimension       | string  | 数据维度                   |
| ├─ metrics         | array   | 统计指标列表               |
| └─ records         | array   | 统计数据记录               |
| &nbsp;&nbsp; ├─ date | string | 日期                     |
| &nbsp;&nbsp; └─ values | object | 各指标的值              |

### 响应示例
```json
{
  "code": 200,
  "msg": "SUCCESS",
  "data": {
    "period": "2024-05-01 至 2024-05-31",
    "dimension": "day",
    "metrics": ["dau", "newUsers", "pluginInstalls"],
    "records": [
      {
        "date": "2024-05-01",
        "values": {
          "dau": 310,
          "newUsers": 25,
          "pluginInstalls": 48
        }
      },
      {
        "date": "2024-05-02",
        "values": {
          "dau": 325,
          "newUsers": 32,
          "pluginInstalls": 52
        }
      },
      {
        "date": "2024-05-03",
        "values": {
          "dau": 315,
          "newUsers": 28,
          "pluginInstalls": 45
        }
      }
    ]
  }
}
```
