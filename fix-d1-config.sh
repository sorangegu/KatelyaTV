#!/bin/bash

echo "🔧 KatelyaTV D1数据库配置修复脚本"
echo "========================================"

# 检查wrangler是否安装
if ! command -v wrangler &> /dev/null; then
    echo "❌ wrangler未安装，正在安装..."
    npm install -g wrangler
fi

# 登录Cloudflare
echo "🔑 请确保已登录Cloudflare:"
echo "wrangler auth login"

# 创建D1数据库
echo "🗄️ 创建D1数据库..."
wrangler d1 create katelyatv-db

# 获取数据库列表
echo "📋 当前D1数据库列表:"
wrangler d1 list

# 提示用户输入数据库ID
echo "📝 请输入上面创建的数据库ID:"
read -p "Database ID: " DB_ID

# 更新wrangler.toml
echo "⚙️ 更新wrangler.toml配置..."
cat >> wrangler.toml << EOF

# 修复后的D1数据库配置
[[d1_databases]]
binding = "DB"
database_name = "katelyatv-db"
database_id = "$DB_ID"
EOF

# 初始化数据库
echo "🚀 初始化数据库结构..."
wrangler d1 execute katelyatv-db --file=./scripts/d1-init.sql

echo "✅ D1数据库配置完成！"
echo "📖 下一步: 重新部署到Cloudflare Pages"
