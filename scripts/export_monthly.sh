#!/bin/bash

# ディレクトリとファイルの設定
DB_DIR="/home/akari/Documents/kakeibo-project/"
DB_FILE="$DB_DIR/kakeibo_2.db"
CSV_FILE="$DB_DIR/monthly.csv"
CSVLOG_DIR="$DB_DIR/csvlog"

# 日付（例：2025-11-04）
DATE=$(date +%Y-%m-%d)

# csvlogディレクトリがなければ作成
mkdir -p "$CSVLOG_DIR"

# 既存のmonthly.csvを退避
if [ -f "$CSV_FILE" ]; then
  mv "$CSV_FILE" "$CSVLOG_DIR/monthly_$DATE.csv"
fi

# SQLiteからCSV出力
sqlite3 "$DB_FILE" <<EOF
.headers on
.mode csv
.output $CSV_FILE
SELECT * FROM monthly_category_totals;
.output stdout
EOF

echo "✅ 新しい monthly.csv を出力しました！"
echo "📦 古いファイルは csvlog に退避しました（$DATE）"
