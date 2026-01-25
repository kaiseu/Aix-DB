---
name: report-generation
description: 通用的报告生成技能，根据用户诉求生成各类数据分析报告，包括数据库查询、统计分析和 HTML 图表可视化
---

# 通用报告生成技能

## 何时使用此技能

当用户需要生成任何类型的报告时使用此技能，包括但不限于：
- **业务报告**：销售报告、收入分析、业绩统计、财务报表
- **数据分析报告**：趋势分析、对比分析、分布分析、相关性分析
- **统计报告**：汇总统计、排名报告、占比分析、异常检测
- **运营报告**：用户行为分析、产品使用统计、系统监控报告、运营指标
- **自定义报告**：根据用户具体需求定制的任何报告

**关键特征：**
- 能够理解用户的自然语言诉求
- 自动识别报告类型和数据需求
- 生成专业的可视化报告
- 支持多种报告格式和图表类型

## 工作流程

### 1. 理解用户诉求

仔细分析用户的报告需求，识别以下关键信息：

- **报告类型**：用户想要什么类型的报告？（销售、用户、产品、运营、财务等）
- **数据维度**：需要按什么维度分析？（时间、地区、类别、用户、产品等）
- **关键指标**：用户关注哪些指标？（总量、平均值、增长率、排名、占比等）
- **时间范围**：需要分析哪个时间段的数据？（最近一周、一个月、一年等）
- **对比需求**：是否需要对比分析？（同比、环比、不同类别对比等）
- **可视化需求**：用户希望看到什么类型的图表？（趋势图、对比图、分布图、排名图等）
- **报告格式**：是否需要摘要、详细数据、图表、结论、建议等

**常见报告诉求示例：**
- "生成一份销售报告，显示过去一年的月度销售趋势"
- "分析用户活跃度，按地区统计用户数量并生成可视化报告"
- "生成产品库存报告，显示各产品的库存状态和预警"
- "创建一个收入分析报告，对比不同渠道的收入占比"
- "生成一份客户满意度报告，按月份统计评分趋势"
- "分析网站访问数据，生成用户行为分析报告"
- "生成员工绩效报告，按部门统计业绩排名"

### 2. 探索数据库架构

根据用户诉求，使用 `sql_db_list_tables` 和 `sql_db_schema` 查找相关表：

- **识别相关表**：根据报告类型找到对应的数据表
  - 销售报告 → 订单表、发票表、产品表
  - 用户报告 → 用户表、活动表、登录表
  - 产品报告 → 产品表、库存表、订单明细表
  - 运营报告 → 日志表、事件表、指标表

- **查找关键字段**：
  - **日期/时间列**：用于时间序列分析（created_at, updated_at, date, timestamp 等）
  - **数值列**：用于聚合计算（金额、数量、评分、计数等）
  - **分类列**：用于分组分析（地区、类别、状态、类型等）
  - **标识列**：用于关联和展示（ID、名称、代码等）

- **映射表关系**：理解表之间的外键关系，确定如何 JOIN 多个表

### 3. 设计查询策略

根据报告需求设计 SQL 查询：

- **过滤条件**：确定 WHERE 子句（时间范围、状态、类别、条件等）
- **聚合函数**：选择合适的聚合函数
  - SUM - 求和（金额、数量）
  - COUNT - 计数（记录数、用户数）
  - AVG - 平均值（评分、价格）
  - MAX/MIN - 最值（最大值、最小值）
  - STDDEV - 标准差（数据分布）
  - PERCENTILE - 百分位数（中位数、分位数）

- **分组维度**：确定 GROUP BY 字段（时间、地区、类别、用户等）
- **排序规则**：确定 ORDER BY 字段（按数值降序、按时间升序等）
- **计算字段**：需要时计算百分比、增长率、占比等衍生指标
- **数据限制**：合理使用 LIMIT（默认显示前 N 条，除非用户要求全部）

**查询设计原则：**
- 只查询必要的列，避免 SELECT *
- 使用表别名提高可读性
- 对于复杂查询，先用 `write_todos` 规划步骤
- 确保所有 JOIN 都有明确的连接条件
- 验证 GROUP BY 包含所有非聚合列
- 使用适当的日期函数处理时间维度

### 4. 生成带图表的 HTML 报告

根据报告类型和用户需求，生成专业的 HTML 报告。HTML 报告应包含：

**报告结构：**
- **报告标题** - 清晰描述报告内容和时间范围
- **摘要统计卡片** - 顶部展示关键指标（KPI），如总计、平均值、最大值、增长率等
- **可视化图表** - 使用 Chart.js 库创建交互式图表：
  - **折线图** - 用于时间趋势分析（月度趋势、年度趋势、日趋势等）
  - **柱状图** - 用于类别对比（地区对比、产品对比、部门对比等）
  - **饼图/环形图** - 用于占比分布（市场份额、类别占比、状态分布等）
  - **面积图** - 用于累积数据展示
  - **组合图** - 多个指标在同一图表中展示（柱状图+折线图）
  - **散点图** - 用于相关性分析
  - **雷达图** - 用于多维度对比

- **详细数据表格** - 完整的数据列表，支持排序和筛选
- **分析结论** - 简要的数据洞察和发现（可选，根据用户需求）

**图表类型选择指南：**
- **时间序列数据** → 折线图或面积图
- **类别对比** → 柱状图（垂直或水平）
- **占比分析** → 饼图或环形图
- **多指标对比** → 组合图（柱状图+折线图）
- **排名展示** → 水平柱状图
- **相关性分析** → 散点图
- **多维度对比** → 雷达图

**关于 HTML 生成的重要说明：**
- 直接生成完整的 HTML 内容作为单个字符串
- 应用 UI/UX 最佳实践，包括专业的配色方案和优雅的排版
- 根据报告类型选择合适的配色方案（业务报告用专业色调，数据报告用清晰对比色）
- HTML 字符串应传递给 `upload_html_report_to_minio` 工具进行上传

### 5. 上传 HTML 报告到 MinIO 并返回 URL

**重要：** 生成 HTML 报告后，您必须自动将其上传到 MinIO 并向用户返回可点击的 URL。

**自动上传流程：**

**方法 1：直接上传 HTML 内容（推荐）**
将 HTML 内容生成为字符串后，使用 `upload_html_report_to_minio` 工具：

```
使用工具：upload_html_report_to_minio
参数：
  - html_content: (字符串) 完整的 HTML 报告内容
  - file_name: (可选) 自定义文件名，例如 "user_analysis_report_2024_01.html"
    如果未提供，自动生成： "report_YYYYMMDD_HHMMSS.html"
  - bucket_name: (可选) 默认为 "filedata"
```

**示例工作流程：**
1. 将 HTML 内容生成为字符串变量
2. 使用 HTML 内容调用 `upload_html_report_to_minio` 工具
3. 工具返回预签名 URL（有效期为 7 天）
4. 格式化并向用户返回 URL

**方法 2：上传已保存的 HTML 文件**
如果您先将 HTML 保存到文件，使用 `upload_html_file_to_minio`：

```
使用工具：upload_html_file_to_minio
参数：
  - file_path: (字符串) HTML 文件的完整路径
  - file_name: (可选) MinIO 的自定义文件名
  - bucket_name: (可选) 默认为 "filedata"
```

**以格式化的可点击链接形式向用户返回 URL：**
```
📊 **报告已生成**

🔗 <a href="{report_url}" target="_blank" rel="noopener noreferrer">点击打开新标签页查看完整报告</a>

报告包含：
- 数据统计分析
- 可视化图表
- 详细数据表格

链接有效期：7天
```
- URL 是有效期为 7 天的预签名 URL
- 前端可以在新的浏览器标签页/窗口中直接打开此 URL
- 用户可以收藏或分享该 URL

**关键要点：**
- **始终使用上传工具** - 绝不跳过上传步骤
- 工具自动处理所有 MinIO 操作
- 如果未指定，文件名会自动生成带时间戳
- MinIO URL 允许直接浏览器访问 - 7 天内无需身份验证
- 清晰地格式化响应，以便用户知道可以点击链接
- 包含报告中内容的简要描述
- 文件名应具有描述性，反映报告类型和内容

### 6. 应用 UI/UX Pro Max 设计原则

**重要：** 生成 HTML 时，应用 UI/UX Pro Max 设计原则以获得专业、美观的输出。

**要应用的设计原则：**
- 使用专业的配色方案和优雅的排版
- 确保响应式设计和可访问性
- 生成生产就绪的 HTML 代码
- 参考 `ui-ux-pro-max` 技能获取设计指导

**要使用子代理：**
- 使用 `task` 工具，设置 `agent: "html_generator"`
- 为 HTML 内容提供清晰的要求
- 子代理处理所有设计和实现细节

### 7. UI/UX 设计原则（由子代理自动应用）

`html_generator` 子代理自动应用这些原则。供参考：
- **配色方案** - 根据报告类型选择合适的配色方案
  - 业务报告：使用专业色调（slate/gray/blue）
  - 数据报告：使用清晰对比色（blue/green/purple）
  - 财务报告：使用保守色调（navy/gray）
  - 运营报告：使用活力色调（blue/teal/orange）

- **排版** - 选择优雅、可读的字体配对（Google Fonts）
  - 标题：Playfair Display, Merriweather, Lora
  - 正文：Inter, Roboto, Open Sans

- **布局和间距** - 适当的填充、边距和响应式设计
- **视觉层次** - 清晰的部分分隔、基于卡片的布局
- **深色/浅色模式** - 支持两种模式，具有适当的对比度
- **可访问性** - 确保足够的颜色对比度、可读字体

**报告的关键 UI/UX 指南：**
- 使用**基于卡片的布局**，带有微妙的阴影和边框
- 应用**一致的间距**（使用 Tailwind 间距比例：p-4, p-6, p-8）
- 使用**专业的配色方案** - 避免明亮/霓虹色
- 确保文本的**高对比度**（最小 4.5:1 比例）
- 为悬停状态添加**平滑过渡**（150-300ms）
- 使图表**响应式** - 使用容器查询或百分比宽度
- 如果数据量大，为图表包含**加载状态**
- 使用**一致的图标集**（Heroicons, Lucide）- 不使用表情符号作为图标
- 为所有交互元素添加 **cursor-pointer**

**示例：应用 UI/UX 原则**
```
1. 根据报告类型选择专业的配色方案
2. 选择优雅的排版（Google Fonts）
3. 使用具有适当间距的基于卡片的布局
4. 确保响应式设计（移动优先方法）
5. 添加平滑过渡和悬停效果
6. 支持浅色和深色模式
```

### 8. HTML 图表格式

通过 CDN 使用 Chart.js 创建交互式图表。HTML 应该：
- 从 CDN 包含 Chart.js 库
- 为每个图表创建 canvas 元素
- 将数据格式化为 JavaScript 数组
- 根据数据使用适当的图表类型
- 包含标签、颜色和图例
- 使图表响应式且视觉上吸引人
- **应用 UI/UX Pro Max 配色方案** - 使用专业、可访问的颜色
- **确保图表可访问性** - 高对比度、可读标签

## 示例：用户活跃度分析报告

**步骤 1：** 理解用户诉求
用户要求："分析用户活跃度，按地区统计用户数量，并生成可视化报告"

**步骤 2：** 探索数据库架构
```sql
-- 查找用户相关表
sql_db_list_tables
sql_db_schema(table_name="users")
sql_db_schema(table_name="user_activities")
```

**步骤 3：** 查询用户活跃度数据
```sql
SELECT
    u.region,
    COUNT(DISTINCT u.user_id) as total_users,
    COUNT(DISTINCT ua.activity_id) as total_activities,
    AVG(ua.activity_count) as avg_activities_per_user,
    MAX(ua.last_active_date) as last_active_date
FROM users u
LEFT JOIN user_activities ua ON u.user_id = ua.user_id
WHERE ua.last_active_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY u.region
ORDER BY total_users DESC;
```

**步骤 4：** 生成带图表的 HTML 报告并上传到 MinIO

**在生成 HTML 之前，应用 UI/UX Pro Max 原则：**
- 使用专业的配色方案（根据报告类型选择合适的色调）
- 应用优雅的排版（Google Fonts: Inter + Playfair Display）
- 使用具有适当间距的基于卡片的布局
- 确保响应式设计
- 支持浅色/深色模式
- 添加平滑过渡

首先，使用 UI/UX Pro Max 样式创建 HTML 内容：
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户活跃度分析报告</title>
    <!-- Google Fonts - 专业排版 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            /* 专业配色方案 - 浅色模式 */
            --bg-primary: #ffffff;
            --bg-secondary: #f8fafc;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --border-color: #e2e8f0;
            --accent-color: #3b82f6;
            --accent-hover: #2563eb;
            --card-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --card-shadow-hover: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        }

        @media (prefers-color-scheme: dark) {
            :root {
                /* 深色模式颜色 */
                --bg-primary: #0f172a;
                --bg-secondary: #1e293b;
                --text-primary: #f1f5f9;
                --text-secondary: #cbd5e1;
                --border-color: #334155;
                --accent-color: #60a5fa;
                --accent-hover: #3b82f6;
            }
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: var(--bg-secondary);
            color: var(--text-primary);
            line-height: 1.6;
            padding: 2rem 1rem;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* 基于卡片的布局 */
        .card {
            background: var(--bg-primary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            transition: box-shadow 0.3s ease, transform 0.2s ease;
        }

        .card:hover {
            box-shadow: var(--card-shadow-hover);
        }

        /* 报告标题 */
        .report-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .report-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .report-header p {
            font-size: 1.125rem;
            color: var(--text-secondary);
        }

        /* 摘要统计卡片 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--bg-primary);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--card-shadow-hover);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent-color);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 0.875rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        /* 图表容器 */
        .chart-container {
            width: 100%;
            height: 400px;
            margin: 2rem 0;
            position: relative;
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        /* 表格样式 */
        .table-wrapper {
            overflow-x: auto;
            border-radius: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--bg-primary);
        }

        th {
            background: var(--accent-color);
            color: white;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        tr:hover {
            background: var(--bg-secondary);
            transition: background-color 0.2s ease;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            body {
                padding: 1rem 0.5rem;
            }

            .card {
                padding: 1.5rem;
            }

            .report-header h1 {
                font-size: 2rem;
            }

            .chart-container {
                height: 300px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        /* 可访问性 */
        @media (prefers-reduced-motion: reduce) {
            * {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 报告标题卡片 -->
        <div class="card report-header">
            <h1>用户活跃度分析报告</h1>
            <p>期间：2024年1月 - 2024年12月</p>
        </div>

        <!-- 摘要统计卡片 -->
        <div class="card">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value">15,234</div>
                    <div class="stat-label">总用户数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">89,456</div>
                    <div class="stat-label">总活动数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">5.87</div>
                    <div class="stat-label">平均活跃度</div>
                </div>
            </div>
        </div>

        <!-- 图表卡片 - 柱状图 -->
        <div class="card">
            <div class="chart-title">按地区用户数量分布</div>
            <div class="chart-container">
                <canvas id="barChart"></canvas>
            </div>
        </div>

        <!-- 图表卡片 - 饼图 -->
        <div class="card">
            <div class="chart-title">各地区用户占比</div>
            <div class="chart-container">
                <canvas id="pieChart"></canvas>
            </div>
        </div>

        <!-- 数据表格卡片 -->
        <div class="card">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>地区</th>
                            <th>用户数</th>
                            <th>活动数</th>
                            <th>平均活跃度</th>
                            <th>最后活跃日期</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- 数据行在这里 -->
                        <tr>
                            <td>华东</td>
                            <td>5,234</td>
                            <td>32,456</td>
                            <td>6.2</td>
                            <td>2024-12-25</td>
                        </tr>
                        <tr>
                            <td>华南</td>
                            <td>4,567</td>
                            <td>28,123</td>
                            <td>6.1</td>
                            <td>2024-12-24</td>
                        </tr>
                        <tr>
                            <td>华北</td>
                            <td>3,890</td>
                            <td>21,234</td>
                            <td>5.5</td>
                            <td>2024-12-23</td>
                        </tr>
                        <tr>
                            <td>西南</td>
                            <td>1,543</td>
                            <td>7,643</td>
                            <td>5.0</td>
                            <td>2024-12-22</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // 检测颜色方案偏好
        const isDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches;

        // 专业配色方案
        const colors = {
            light: {
                primary: '#3b82f6',
                secondary: '#8b5cf6',
                accent: '#10b981',
                warning: '#f59e0b',
                danger: '#ef4444',
                background: 'rgba(59, 130, 246, 0.1)'
            },
            dark: {
                primary: '#60a5fa',
                secondary: '#a78bfa',
                accent: '#34d399',
                warning: '#fbbf24',
                danger: '#f87171',
                background: 'rgba(96, 165, 250, 0.1)'
            }
        };

        const palette = isDarkMode ? colors.dark : colors.light;

        // 柱状图配置
        const barCtx = document.getElementById('barChart').getContext('2d');
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: ['华东', '华南', '华北', '西南', '东北', '西北'],
                datasets: [{
                    label: '用户数量',
                    data: [5234, 4567, 3890, 1543, 890, 110],
                    backgroundColor: palette.primary,
                    borderColor: palette.primary,
                    borderWidth: 2,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: false
                    },
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
                        grid: {
                            color: isDarkMode ? 'rgba(203, 213, 225, 0.1)' : 'rgba(226, 232, 240, 0.5)',
                            display: false
                        },
                        ticks: {
                            color: isDarkMode ? '#cbd5e1' : '#475569',
                            font: {
                                family: 'Inter',
                                size: 12
                            }
                        }
                    },
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: isDarkMode ? 'rgba(203, 213, 225, 0.1)' : 'rgba(226, 232, 240, 0.5)',
                            display: true
                        },
                        ticks: {
                            color: isDarkMode ? '#cbd5e1' : '#475569',
                            font: {
                                family: 'Inter',
                                size: 12
                            }
                        }
                    }
                }
            }
        });

        // 饼图配置
        const pieCtx = document.getElementById('pieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['华东', '华南', '华北', '西南', '东北', '西北'],
                datasets: [{
                    data: [5234, 4567, 3890, 1543, 890, 110],
                    backgroundColor: [
                        palette.primary,
                        palette.secondary,
                        palette.accent,
                        palette.warning,
                        '#a78bfa',
                        '#f472b6'
                    ],
                    borderWidth: 2,
                    borderColor: isDarkMode ? '#1e293b' : '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: false
                    },
                    legend: {
                        display: true,
                        position: 'right',
                        labels: {
                            font: {
                                family: 'Inter',
                                size: 12
                            },
                            color: isDarkMode ? '#cbd5e1' : '#475569',
                            usePointStyle: true,
                            padding: 15
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
```

**折线图示例（用于时间趋势分析）：**
```html
<!-- 折线图卡片 -->
<div class="card">
    <div class="chart-title">月度活跃度趋势</div>
    <div class="chart-container">
        <canvas id="lineChart"></canvas>
    </div>
</div>

<script>
    // 折线图配置
    const lineCtx = document.getElementById('lineChart').getContext('2d');
    new Chart(lineCtx, {
        type: 'line',
        data: {
            labels: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
            datasets: [{
                label: '活跃用户数',
                data: [12000, 13500, 14200, 15800, 16500, 17200, 18000, 17500, 18200, 19000, 19500, 20000],
                borderColor: palette.primary,
                backgroundColor: palette.background,
                tension: 0.4,
                fill: true,
                borderWidth: 3,
                pointRadius: 5,
                pointHoverRadius: 7,
                pointBackgroundColor: palette.primary,
                pointBorderColor: '#ffffff',
                pointBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: false
                },
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        font: {
                            family: 'Inter',
                            size: 12
                        },
                        color: isDarkMode ? '#cbd5e1' : '#475569',
                        usePointStyle: true,
                        padding: 15
                    }
                }
            },
            scales: {
                x: {
                    grid: {
                        color: isDarkMode ? 'rgba(203, 213, 225, 0.1)' : 'rgba(226, 232, 240, 0.5)',
                        display: true
                    },
                    ticks: {
                        color: isDarkMode ? '#cbd5e1' : '#475569',
                        font: {
                            family: 'Inter',
                            size: 12
                        }
                    }
                },
                y: {
                    beginAtZero: true,
                    grid: {
                        color: isDarkMode ? 'rgba(203, 213, 225, 0.1)' : 'rgba(226, 232, 240, 0.5)',
                        display: true
                    },
                    ticks: {
                        color: isDarkMode ? '#cbd5e1' : '#475569',
                        font: {
                            family: 'Inter',
                            size: 12
                        }
                    }
                }
            }
        }
    });
</script>
```

**组合图示例（柱状图+折线图，用于多指标对比）：**
```html
<!-- 组合图卡片 -->
<div class="card">
    <div class="chart-title">收入与增长率对比</div>
    <div class="chart-container">
        <canvas id="comboChart"></canvas>
    </div>
</div>

<script>
    // 组合图配置
    const comboCtx = document.getElementById('comboChart').getContext('2d');
    new Chart(comboCtx, {
        type: 'bar',
        data: {
            labels: ['1月', '2月', '3月', '4月', '5月', '6月'],
            datasets: [
                {
                    type: 'bar',
                    label: '收入（万元）',
                    data: [120, 150, 180, 200, 220, 250],
                    backgroundColor: palette.primary,
                    borderColor: palette.primary,
                    borderWidth: 2,
                    borderRadius: 8,
                    yAxisID: 'y'
                },
                {
                    type: 'line',
                    label: '增长率（%）',
                    data: [0, 25, 20, 11, 10, 14],
                    borderColor: palette.accent,
                    backgroundColor: 'transparent',
                    borderWidth: 3,
                    tension: 0.4,
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    yAxisID: 'y1'
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: false
                },
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        font: {
                            family: 'Inter',
                            size: 12
                        },
                        color: isDarkMode ? '#cbd5e1' : '#475569',
                        usePointStyle: true,
                        padding: 15
                    }
                }
            },
            scales: {
                x: {
                    grid: {
                        color: isDarkMode ? 'rgba(203, 213, 225, 0.1)' : 'rgba(226, 232, 240, 0.5)',
                        display: false
                    },
                    ticks: {
                        color: isDarkMode ? '#cbd5e1' : '#475569',
                        font: {
                            family: 'Inter',
                            size: 12
                        }
                    }
                },
                y: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    beginAtZero: true,
                    grid: {
                        color: isDarkMode ? 'rgba(203, 213, 225, 0.1)' : 'rgba(226, 232, 240, 0.5)',
                        display: true
                    },
                    ticks: {
                        color: isDarkMode ? '#cbd5e1' : '#475569',
                        font: {
                            family: 'Inter',
                            size: 12
                        }
                    }
                },
                y1: {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    beginAtZero: true,
                    grid: {
                        drawOnChartArea: false
                    },
                    ticks: {
                        color: isDarkMode ? '#cbd5e1' : '#475569',
                        font: {
                            family: 'Inter',
                            size: 12
                        },
                        callback: function(value) {
                            return value + '%';
                        }
                    }
                }
            }
        }
    });
</script>
```

然后使用工具自动上传到 MinIO：
```
使用工具：upload_html_report_to_minio
参数：
  html_content: """<!DOCTYPE html>..."""  # 您的完整 HTML 内容
  file_name: "user_activity_report_2024_01.html"  # 可选，如果未提供则自动生成
  bucket_name: "filedata"  # 可选，默认为 "filedata"

工具自动返回预签名 URL。

然后格式化响应：
📊 **报告已生成**

🔗 <a href="{report_url}" target="_blank" rel="noopener noreferrer">点击打开新标签页查看完整报告</a>

报告包含：
- 数据统计分析
- 可视化图表
- 详细数据表格

链接有效期：7天
```

## 图表类型选择指南

**折线图** - 用于：
- 时间趋势
- 比较多个时间序列
- 显示变化和模式
- 预测趋势

**柱状图** - 用于：
- 比较类别
- 排名项目
- 显示组间差异
- 对比不同维度

**饼图** - 用于：
- 显示比例/百分比
- 整体的分布
- 当您有 2-7 个类别时
- 展示占比关系

**面积图** - 用于：
- 时间上的累积值
- 显示数量/体积趋势
- 堆叠比较
- 展示累积变化

**组合图** - 用于：
- 多个指标在同一图表中展示
- 不同量级的指标对比
- 趋势和总量的结合展示

## 质量指南

**对于 SQL 查询：**
- 始终使用适当的日期过滤器
- 包含有意义的聚合
- 按相关维度分组
- 逻辑地排序结果
- 限制为合理的行数（除非用户指定）
- 使用适当的日期函数处理时间维度
- 验证 JOIN 条件和 GROUP BY 子句

**对于 HTML 报告：**
- **应用 UI/UX Pro Max 原则** - 参考 `ui-ux-pro-max` 技能获取设计指南
- 使用**专业的配色方案** - 根据报告类型选择合适的色调
- 应用**优雅的排版** - 使用 Google Fonts（Inter, Playfair Display 等）
- 使用**基于卡片的布局** - 适当的间距、阴影、边框
- 确保**响应式设计** - 移动优先方法，在 320px、768px、1024px 测试
- 支持**浅色/深色模式** - 使用 CSS 变量，尊重 `prefers-color-scheme`
- 包含**平滑过渡** - 悬停状态 150-300ms
- 添加**适当的对比度** - 文本可读性最小 4.5:1
- 使用**一致的图标集** - Heroicons 或 Lucide，不使用表情符号作为图标
- 包含清晰的标题和日期范围
- 突出显示摘要统计
- 使用适当的图表类型
- 包含详细视图的数据表格
- 使图表响应式且可读
- 添加图例和标签以提高清晰度
- **始终将 HTML 文件上传到 MinIO 并返回 URL**
- 在响应中将 URL 格式化为可点击链接
- 使用描述性文件名（例如，`user_analysis_report_2024_01.html`）

**对于统计分析：**
- 计算总计、平均值、计数
- 相关时显示百分比
- 比较时间段或类别
- 突出趋势和模式
- 识别表现最佳/最差者
- 计算增长率和变化率

## 常见报告模式

### 模式 1：时间序列报告
"显示过去一年的月度销售趋势"
→ 使用 DATE_TRUNC 查询，按月份 GROUP BY，按月份 ORDER BY
→ 使用折线图或柱状图

### 模式 2：类别比较
"按地区比较用户数量"
→ 使用 GROUP BY region 查询
→ 使用柱状图或饼图

### 模式 3：表现最佳者
"显示销售额排名前 10 的产品"
→ 使用 ORDER BY sales DESC LIMIT 10 查询
→ 使用柱状图（水平）

### 模式 4：趋势分析
"显示月度环比增长率"
→ 使用窗口函数或自连接查询
→ 使用带百分比计算的折线图

### 模式 5：占比分析
"分析各渠道的收入占比"
→ 使用 GROUP BY 和百分比计算
→ 使用饼图或环形图

### 模式 6：多维度分析
"分析用户行为，按地区和年龄段统计"
→ 使用多维度 GROUP BY
→ 使用组合图或分组柱状图

## 提示

- 执行前始终验证 SQL 查询
- 在 SQL 中使用适当的日期格式
- 在 HTML 中使用逗号和货币符号格式化数字
- **生成 HTML 之前，咨询 `ui-ux-pro-max` 技能**获取设计最佳实践
- 选择可访问且专业的图表颜色（使用 UI/UX Pro Max 配色方案）
- 为完整性包含可视化图表和数据表格
- 在报告标题中添加简要分析或见解
- 使用响应式设计以在不同屏幕上更好地显示
- **在最终确定 HTML 之前应用 UI/UX Pro Max 检查清单**：
  - [ ] 应用了专业配色方案
  - [ ] 优雅的排版（Google Fonts）
  - [ ] 具有适当间距的基于卡片的布局
  - [ ] 在所有断点响应式
  - [ ] 支持浅色/深色模式
  - [ ] 高对比度以确保可访问性
  - [ ] 平滑过渡（150-300ms）
  - [ ] 不使用表情符号作为图标
  - [ ] 一致的图标集（Heroicons/Lucide）
- **记住将 HTML 报告上传到 MinIO** - 绝不直接返回 HTML 内容
- MinIO URL 允许前端在新标签页/窗口中打开报告
- 文件名应具有描述性，并在相关时包含时间戳或日期范围
- 根据用户诉求灵活调整报告内容和格式
- 如果用户需求不明确，主动询问澄清关键信息
