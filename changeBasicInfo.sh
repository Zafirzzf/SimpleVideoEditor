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
if [ -z "$BUNDLE_ID" ] || [ -z "$PRODUCT_NAME" ] || [ -z "$APP_ID_NAME" ] || [ -z "$APP_SLOT_IDS" ] || [ -z "$APP_ID_VALUE" ] || [ -z "$APP_SLOT_IDS_VALUE" ]; then
    echo "配置文件中的某些必要信息未被设置."
    exit 1
fi

# 定义你的xcodeproj文件路径
PROJECT_FILE="/Users/blued/Desktop/myself/SimpleVideoEditor/SimpleVideoEditor.xcodeproj/project.pbxproj"
INFO_PLIST_PATH="/Users/blued/Desktop/myself/SimpleVideoEditor/SimpleVideoEditor/SimpleVideoEditor/Info.plist"
CLASS_FILE_PATH="/Users/blued/Desktop/myself/SimpleVideoEditor/SimpleVideoEditor/Util/CSJAdConfig.swift"

sed -i '' -e "s/\([^[:space:]/]*\)\.app\([;]\)/\"$PRODUCT_NAME.app\";/g" -e "s/\([^[:space:]/]*\)\.app\([\"*]\)/\"$PRODUCT_NAME.app\2/g" -e "s/\([^[:space:]/]*\)\.app \*/\"$PRODUCT_NAME.app\" */g" $PROJECT_FILE

sed -i '' "s/\(PRODUCT_NAME = \).*;/\1\"$PRODUCT_NAME\";/g" "$PROJECT_FILE"

sed -i '' "s/\(PRODUCT_BUNDLE_IDENTIFIER = \).*;/\1$BUNDLE_ID;/g" "$PROJECT_FILE"
sed -i '' "s/\(CURRENT_PROJECT_VERSION = \).*;/\1$BUILD_VERSION;/g" "$PROJECT_FILE"

# 更新类变量
sed -i '' "s/^\(.*$APP_ID_NAME.*=\).*$/\1 \"$APP_ID_VALUE\" /" "$CLASS_FILE_PATH"

sed -i '' "s/^\(.*$APP_SLOT_IDS.*=\).*$/\1 \[\"$APP_SLOT_IDS_VALUE\"\] /" "$CLASS_FILE_PATH"


echo "更新完成."

