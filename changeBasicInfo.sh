#!/bin/zsh

# 定义配置文件路径
CONFIG_FILE="/Users/blued/Desktop/simpleAdConfig.txt"

# 检查配置文件是否存在
if [ ! -f $CONFIG_FILE ]; then
    echo "配置文件不存在."
    exit 1
fi

# 从配置文件中读取变量
export $(cat $CONFIG_FILE | xargs)

# 检查变量是否被正确读取
if [ -z "$BUNDLE_ID" ] || [ -z "$PRODUCT_NAME" ] || [ -z "$CLASS_VARIABLE_NAME" ] || [ -z "$CLASS_VARIABLE_VALUE" ] || [ -z "$BUILD_VERSION" ]; then
    echo "配置文件中的某些必要信息未被设置."
    exit 1
fi

# 定义你的xcodeproj文件路径
PROJECT_FILE="SimpleVideoEditor.xcodeproj/project.pbxproj"
INFO_PLIST_PATH="SimpleVideoEditor/Info.plist"
CLASS_FILE_PATH="SimpleVideoEditor/Util/CSJAdConfig.swift"

sed -i '' -e "s/\([a-zA-Z0-9_.-]*\)\.app \*/$PRODUCT_NAME.app */g" -e "s/\"\([a-zA-Z0-9_.-]*\)\.app\"/\"$PRODUCT_NAME.app\"/g" PROJECT_FILE

sed -i '' "s/\(PRODUCT_BUNDLE_IDENTIFIER = \).*;/\1$BUNDLE_ID;/g" "$PROJECT_FILE"
sed -i '' "s/\(CURRENT_PROJECT_VERSION = \).*;/\1$BUILD_VERSION;/g" "$PROJECT_FILE"

# 更新类变量
sed -i '' "s/^\(.*$CLASS_VARIABLE_NAME.*=\).*$/\1 \"$CLASS_VARIABLE_VALUE\" /" "$CLASS_FILE_PATH"



echo "更新完成."

