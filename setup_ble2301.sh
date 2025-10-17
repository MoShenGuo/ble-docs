#!/bin/bash
# ====================================================
# 一键配置 ble2301 SDK 访问 (Deploy Key + 测试 + 克隆 + 引用提示)
# ====================================================

# 当前目录
CURRENT_DIR=$(pwd)
SDK_NAME="ble2301"
KEY_FILE="$CURRENT_DIR/ble2301_deploy_key"

# 检查私钥文件是否存在
if [ ! -f "$KEY_FILE" ]; then
  echo "❌ 未找到私钥文件: $KEY_FILE"
  echo "请确认 ble2301_deploy_key 已放在当前目录"
  exit 1
fi

echo "🔹 设置私钥权限..."
chmod 600 "$KEY_FILE"

echo "🔹 启动 ssh-agent 并添加私钥..."
eval "$(ssh-agent -s)"
ssh-add "$KEY_FILE"

echo "🔹 测试 GitHub SSH 连接..."
ssh -T git@github.com || { echo "❌ SSH 连接失败，请检查 Deploy Key"; exit 1; }

# 打印 Flutter / RN 引用方式
echo ""
echo "✅ 配置完成！SDK 仓库已克隆到 $CLONE_DIR"
echo ""
echo "Flutter 引用示例 (pubspec.yaml):"
echo "dependencies:"
echo "  ble2301:"
echo "    git:"
echo "      url: git@github.com:MoShenGuo/ble2301.git"
echo "      ref: master"
echo ""
echo "React Native / npm 引用示例 (package.json):"
echo "{"
echo "  \"dependencies\": {"
echo "    \"@moshenguo/ble2301\": \"git+ssh://git@github.com:MoShenGuo/ble2301.git\""
echo "  }"
echo "}"

