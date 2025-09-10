#!/bin/bash

echo "🚀 开始git提交过程..."

# 检查git状态
echo "📋 当前git状态："
git status

# 添加所有更改
echo "➕ 添加所有更改到暂存区..."
git add .

# 显示将要提交的文件
echo "📁 将要提交的文件："
git diff --cached --name-only

# 提交更改
echo "💾 提交更改..."
git commit -m "fix: 修复Cloudflare Pages构建问题

- 修复空API路由文件 /api/test/simple/route.ts
- 添加edge runtime配置到所有API路由
- 更新D1数据库配置
- 添加构建修复指南和检查脚本"

# 显示提交结果
echo "✅ 提交完成！"
git log --oneline -1

# 显示状态
echo "📊 当前状态："
git status
