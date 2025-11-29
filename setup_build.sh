#!/bin/bash

# Kiwi Browser 编译设置脚本

echo "=== Kiwi Browser 编译设置脚本 ==="

# 检查是否以root用户运行
if [ "$EUID" -eq 0 ]; then
  echo "警告：以root用户运行depot_tools可能会导致问题"
fi

# 设置depot_tools路径
export PATH=$PATH:/root/depot_tools

echo "1. 检查depot_tools工具链..."
if ! command -v gclient &> /dev/null; then
  echo "错误：未找到gclient命令，请确保depot_tools已正确安装并添加到PATH"
  exit 1
fi

echo "2. 检查Git..."
if ! command -v git &> /dev/null; then
  echo "错误：未找到git命令，请安装Git"
  exit 1
fi

echo "3. 检查Python..."
if ! command -v python3 &> /dev/null; then
  echo "错误：未找到python3命令，请安装Python 3"
  exit 1
fi

echo "4. 同步依赖..."
gclient sync

if [ $? -ne 0 ]; then
  echo "错误：依赖同步失败"
  exit 1
fi

echo "5. 生成编译配置..."
gn gen out/Default

if [ $? -ne 0 ]; then
  echo "错误：编译配置生成失败"
  exit 1
fi

echo "6. 开始编译..."
ninja -C out/Default chrome

if [ $? -ne 0 ]; then
  echo "错误：编译失败"
  exit 1
fi

echo "=== 编译完成！ ==="
echo "编译产物位于：out/Default/chrome"
