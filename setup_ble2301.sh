#!/bin/bash
# ====================================================
# 一键配置 ble2301 SDK 访问 (Deploy Key + 测试 + 克隆 + 引用提示)
# ====================================================

SDK_NAME="ble2301"
CURRENT_DIR=$(pwd)
KEY_FILE="$CURRENT_DIR/ble2301_deploy_key"
CLONE_DIR="$CURRENT_DIR/$SDK_NAME"

echo "============================================"
echo "🔧 ble2301 SDK 一键配置脚本"
echo "============================================"

# -----------------------------
# 检查私钥
# -----------------------------
if [ ! -f "$KEY_FILE" ]; then
  echo "❌ 未找到私钥文件: $KEY_FILE"
  echo "➡ 请将 ble2301_deploy_key 放到本目录后重试"
  return 1 2>/dev/null || exit 1
fi

echo "🔹 设置私钥权限..."
chmod 600 "$KEY_FILE"

# -----------------------------
# 启动 ssh-agent
# -----------------------------
echo "🔹 启动 ssh-agent..."
eval "$(ssh-agent -s)"

echo "🔹 添加私钥..."
ssh-add "$KEY_FILE"

# -----------------------------
# 客户端可用性测试
# -----------------------------
echo "🔹 测试 GitHub 仓库访问权限..."

git ls-remote git@github.com:MoShenGuo/ble2301.git > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo ""
  echo "❌ 无法访问仓库：git@github.com:MoShenGuo/ble2301.git"
  echo "⚠ 请确认你的 Deploy Key 是添加到 ble2301 仓库的"
  echo "⚠ 或你的网络允许访问 GitHub SSH: 22 端口"
  return 1 2>/dev/null || exit 1
fi

echo "✔ 权限正常，可访问仓库"

# -----------------------------
# 克隆仓库
# -----------------------------
if [ -d "$CLONE_DIR" ]; then
  echo ""
  echo "ℹ️ 目录已存在：$CLONE_DIR"
  echo "✔ 跳过克隆步骤"
else
  echo ""
  echo "🔹 克隆仓库到：$CLONE_DIR ..."
  git clone git@github.com:MoShenGuo/ble2301.git "$CLONE_DIR"
  
  if [ $? -ne 0 ]; then
    echo "❌ 克隆失败，请检查网络或权限"
    return 1 2>/dev/null || exit 1
  fi
fi

# -----------------------------
# 打印引用说明
# -----------------------------
echo ""
echo "============================================"
echo "🎉 ble2301 SDK 已配置完成"
echo "============================================"
echo ""
echo "📁 本地路径: $CLONE_DIR"
echo ""
echo "📌 Flutter 引用示例 (pubspec.yaml):"
echo ""
echo "dependencies:"
echo "  ble2301:"
echo "    git:"
echo "      url: git@github.com:MoShenGuo/ble2301.git"
echo "      ref: master"
echo ""
echo "📌 React Native / NPM 引用 (package.json):"
echo ""
echo "{"
echo "  \"dependencies\": {"
echo "    \"@moshenguo/ble2301\": \"git+ssh://git@github.com:MoShenGuo/ble2301.git\""
echo "  }"
echo "}"
echo ""
echo "✔️ 使用完成！"
echo ""

