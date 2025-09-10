# Cloudflare Pages构建错误修复指南

## 🚨 错误信息
```
ERROR: Failed to produce a Cloudflare Pages build from the project.
The following routes were not configured to run with the Edge Runtime:
  - /api/test/simple
```

## 🔧 解决方案

### 1. 已修复的问题 ✅
- **空API路由文件**：`/api/test/simple/route.ts` 已添加edge runtime配置

### 2. 验证所有API路由

运行检查脚本：
```bash
node check-edge-runtime.js
```

### 3. 确保所有API路由都有edge runtime配置

**每个API路由文件必须包含**：
```typescript
export const runtime = 'edge';
```

### 4. 修复next.config.js（如果需要）

确保next.config.js包含：
```javascript
const nextConfig = {
  output: 'standalone',
  // 其他配置...
};
```

### 5. 重新构建步骤

#### 本地测试
```bash
# 清理缓存
rm -rf .next

# 重新构建
pnpm build

# 测试Cloudflare Pages构建
pnpm pages:build
```

#### Cloudflare Pages重新部署
1. 访问Cloudflare Pages控制台
2. 选择你的项目
3. 点击"Deploy"重新部署

### 6. 常见构建问题

#### 问题1: 缺少edge runtime
**解决**：在每个API路由文件顶部添加：
```typescript
export const runtime = 'edge';
```

#### 问题2: Node.js依赖问题
**解决**：确保所有依赖兼容Edge Runtime

#### 问题3: 构建输出目录
**确保**：
- `pages_build_output_dir = ".vercel/output/static"` 在wrangler.toml中
- 构建命令使用 `pnpm pages:build`

### 7. 验证修复

**检查清单**：
- [ ] 所有API路由文件包含 `export const runtime = 'edge';`
- [ ] 没有空的路由文件
- [ ] next.config.js配置正确
- [ ] 构建命令正确

### 8. 一键修复脚本

创建 `fix-cloudflare-build.sh`：
```bash
#!/bin/bash

echo "🔧 修复Cloudflare Pages构建问题..."

# 检查并修复空路由文件
if [ ! -s src/app/api/test/simple/route.ts ]; then
    cat > src/app/api/test/simple/route.ts << 'EOF'
export const runtime = 'edge';

export async function GET() {
  return Response.json({ 
    message: "API test endpoint working", 
    timestamp: new Date().toISOString() 
  });
}
EOF
    echo "✅ 修复空API路由文件"
fi

# 运行检查
node check-edge-runtime.js

# 重新构建
echo "🚀 重新构建..."
pnpm pages:build

echo "✅ 修复完成！请重新部署到Cloudflare Pages"
```

## 📝 部署检查

**确保**：
1. 所有API路由有edge runtime配置
2. 没有使用不兼容的Node.js API
3. 数据库配置正确
4. 环境变量设置正确

完成这些修复后，Cloudflare Pages构建应该能够成功。
