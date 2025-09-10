#!/bin/bash

echo "🚀 开始自动git push..."

# 检查git状态
echo "📋 检查git状态..."
git status

# 添加所有更改
echo "➕ 添加所有更改..."
git add .

# 提交更改（如果已有更改）
if git diff --cached --quiet; then
    echo "⚠️ 没有需要提交的更改"
else
    echo "💾 提交更改..."
    git commit -m "fix: 修复Cloudflare Pages构建和D1配置

- 修复空API路由文件 /api/test/simple/route.ts
- 添加edge runtime配置到所有API路由  
- 更新D1数据库配置
- 添加构建修复指南和检查脚本"
fi

# 检查远程仓库
echo "🔍 检查远程仓库..."
git remote -v

# 推送到远程仓库
echo "🚀 推送到远程仓库..."
git push origin main

# 验证推送结果
echo "✅ 推送完成！"
git log --oneline -3
