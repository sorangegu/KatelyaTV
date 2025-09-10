# D1数据库配置修复指南

## 🚨 错误解决

**错误信息**: `Couldn't find a D1 DB with the name or binding 'katelyatv-db'`

**根本原因**: Cloudflare Pages无法找到配置的D1数据库

## 🔧 修复步骤

### 1. 创建D1数据库

#### 方法A: 使用Cloudflare控制台（推荐）
1. 访问 https://dash.cloudflare.com/
2. 选择你的账户
3. 左侧菜单 → **Workers & Pages** → **D1**
4. 点击 **"Create database"**
5. 名称填写: `katelyatv-db`
6. 点击 **"Create"**
7. 记录生成的 **Database ID**

#### 方法B: 使用Wrangler CLI
```bash
# 安装wrangler（如果未安装）
npm install -g wrangler

# 登录Cloudflare
wrangler auth login

# 创建数据库
wrangler d1 create katelyatv-db

# 获取数据库列表
wrangler d1 list
```

### 2. 更新wrangler.toml

**重要**: 已为你更新wrangler.toml，但需要替换实际的数据库ID

打开 `wrangler.toml` 文件，替换以下内容：

```toml
# 第9行 - 替换为你的实际数据库ID
database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# 第42行 - 预览环境数据库ID（可选）
database_id = "你的预览环境数据库ID"
```

### 3. 初始化数据库结构

```bash
# 执行SQL初始化脚本
wrangler d1 execute katelyatv-db --file=./scripts/d1-init.sql

# 验证表结构
wrangler d1 execute katelyatv-db --command="SELECT name FROM sqlite_master WHERE type='table';"
```

### 4. 验证配置

**检查wrangler.toml格式**:
```toml
name = "katelyatv"
compatibility_date = "2024-09-01"
compatibility_flags = ["nodejs_compat"]
pages_build_output_dir = ".vercel/output/static"

# 默认D1数据库配置
[[d1_databases]]
binding = "DB"
database_name = "katelyatv-db"
database_id = "你的实际数据库ID"

# 生产环境配置
[env.production]
name = "katelyatv"

[[env.production.d1_databases]]
binding = "DB"
database_name = "katelyatv-db"
database_id = "你的实际数据库ID"

# 预览环境配置
[env.preview]
name = "katelyatv-preview"

[[env.preview.d1_databases]]
binding = "DB"
database_name = "katelyatv-db"
database_id = "你的预览环境数据库ID"
```

### 5. 重新部署

#### Cloudflare Pages重新部署
1. 访问你的Pages项目
2. 进入 **Settings** → **Functions** → **D1 database bindings**
3. 添加绑定:
   - Variable name: `DB`
   - Database: 选择 `katelyatv-db`
4. 重新部署项目

#### 本地验证
```bash
# 本地测试（需要安装wrangler）
wrangler pages dev .vercel/output/static --d1=DB=katelyatv-db
```

## 📝 常见问题

### Q1: 数据库ID在哪里找？
**A**: 在Cloudflare控制台 → Workers & Pages → D1 → 点击数据库名称 → 查看Database ID

### Q2: binding名称必须是什么？
**A**: 必须使用 `DB`，这是项目代码中硬编码的绑定名称

### Q3: 需要创建多个数据库吗？
**A**: 
- 个人使用: 1个数据库即可
- 完整配置: 创建2个数据库（生产+预览）

### Q4: 如何验证数据库是否工作？
```bash
# 测试查询
wrangler d1 execute katelyatv-db --command="SELECT 1 as test;"
```

## 🚀 一键配置脚本

创建 `setup-d1.sh`：
```bash
#!/bin/bash
# 运行前确保已登录: wrangler auth login

echo "🔧 开始D1数据库配置..."

# 创建数据库
echo "🗄️ 创建D1数据库..."
wrangler d1 create katelyatv-db

# 获取数据库ID
DB_ID=$(wrangler d1 list --json | jq -r '.[] | select(.name=="katelyatv-db") | .uuid')
echo "✅ 数据库ID: $DB_ID"

# 更新wrangler.toml
sed -i '' "s/请替换为你的默认数据库ID/$DB_ID/g" wrangler.toml
sed -i '' "s/请替换为你的实际数据库ID/$DB_ID/g" wrangler.toml

# 初始化数据库
echo "🚀 初始化数据库结构..."
wrangler d1 execute katelyatv-db --file=./scripts/d1-init.sql

echo "✅ D1数据库配置完成！"
echo "📖 请重新部署到Cloudflare Pages"
```

## 📋 检查清单

- [ ] 已创建D1数据库 `katelyatv-db`
- [ ] 已获取正确的数据库ID
- [ ] wrangler.toml中的database_id已更新
- [ ] 已执行d1-init.sql初始化数据库
- [ ] Cloudflare Pages已配置D1绑定
- [ ] 项目重新部署成功
