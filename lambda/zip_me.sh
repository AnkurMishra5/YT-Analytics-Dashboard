#!/bin/bash

echo "🧹 Cleaning old lambda.zip..."
rm -f ../lambda.zip

cd "$(dirname "$0")" || exit

echo "🐍 Creating virtual environment..."
python -m venv .venv

echo "📦 Activating virtual environment and installing dependencies..."
source .venv/Scripts/activate
pip install -r requirements.txt
deactivate

echo "🗂️ Collecting site-packages..."
mkdir -p build
cp -r .venv/Lib/site-packages/* build/

echo "📦 Creating zip archive..."
cd build || exit
zip -r9 ../lambda.zip .
cd ..

echo "➕ Adding lambda_function.py to zip..."
zip -g lambda.zip lambda_function.py

echo "✅ lambda.zip is ready!"
