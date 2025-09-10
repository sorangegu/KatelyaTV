#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const apiRoutesDir = path.join(__dirname, 'src', 'app', 'api');

function checkEdgeRuntime(routePath) {
  const routeFile = path.join(routePath, 'route.ts');
  if (fs.existsSync(routeFile)) {
    const content = fs.readFileSync(routeFile, 'utf8');
    const hasEdgeRuntime = content.includes("runtime = 'edge'") || content.includes('runtime = "edge"');
    
    if (!hasEdgeRuntime) {
      console.log(`❌ Missing edge runtime: ${routeFile}`);
      return false;
    }
    return true;
  }
  return true;
}

function checkAllRoutes(dir) {
  let allGood = true;
  
  function traverse(currentDir) {
    const items = fs.readdirSync(currentDir);
    
    for (const item of items) {
      const fullPath = path.join(currentDir, item);
      const stat = fs.statSync(fullPath);
      
      if (stat.isDirectory()) {
        if (fs.existsSync(path.join(fullPath, 'route.ts'))) {
          if (!checkEdgeRuntime(fullPath)) {
            allGood = false;
          }
        } else {
          traverse(fullPath);
        }
      }
    }
  }
  
  traverse(dir);
  return allGood;
}

console.log('🔍 Checking API routes for edge runtime configuration...');

if (fs.existsSync(apiRoutesDir)) {
  const allConfigured = checkAllRoutes(apiRoutesDir);
  
  if (allConfigured) {
    console.log('✅ All API routes have edge runtime configuration');
  } else {
    console.log('❌ Some API routes are missing edge runtime configuration');
    process.exit(1);
  }
} else {
  console.log('⚠️ API routes directory not found');
}
