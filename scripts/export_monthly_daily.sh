#!/bin/bash

# ディレクトリとファイルの設定
DB_DIR="/home/akari/Documents/kakeibo-project/"
DB_FILE="$DB_DIR/kakeibo_2.db"
CSVLOG_DIR="$DB_DIR/csvlog"
DATE=$(date +%Y-%m-%d)

# csvlogディレクトリがなければ作成
mkdir -p "$CSVLOG_DIR"

# CSV退避関数
backup_csv() {
  local file="$1"
  local name="$2"
  if [ -f "$file" ]; then
    mv "$file" "$CSVLOG_DIR/${name}_$DATE.csv"
    echo "📦 古いファイルは csvlog に退避しました（$DATE）"
  fi
}

# SQLite出力関数
export_csv() {
  local file="$1"
  local query="$2"
  sqlite3 "$DB_FILE" <<EOF
.headers on
.mode csv
.output $file
$query
.output stdout
EOF
  echo "✅ $(basename "$file") を出力しました！"
}

# monthly.csv 出力
MONTHLY_CSV="$DB_DIR/monthly.csv"
backup_csv "$MONTHLY_CSV" "monthly"
export_csv "$MONTHLY_CSV" "SELECT * FROM monthly_category_totals;"

# daily.csv 出力
DAILY_CSV="$DB_DIR/daily.csv"
backup_csv "$DAILY_CSV" "daily"
export_csv "$DAILY_CSV" "SELECT
  t.id,
  t.date,
  t.amount,
  t.memo,
  c.name AS category_name
FROM transactions t
LEFT JOIN categories c ON t.category_id = c.id;"
