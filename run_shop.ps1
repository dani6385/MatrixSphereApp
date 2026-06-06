#!/bin/bash
echo "Sedang memproses Shop App..."
cd apps/shop_app
flutter build web
cd ../..
firebase deploy --only hosting:shop
echo "Shop App berhasil dideploy!"Write-Host "--- Memulai Build & Deploy shop App ---" -ForegroundColor Cyan

# Pindah ke direktori aplikasi
Set-Location -Path "apps/shop_app"

# Melakukan build dengan optimasi penuh
# --release: Memastikan mode release (tercepat & terkecil)
# --web-renderer canvaskit: Memberikan performa grafis terbaik
Write-Host "Sedang melakukan build web (release mode)..." -ForegroundColor Yellow
flutter build web --release --web-renderer canvaskit

# Kembali ke root
Set-Location -Path "../../"

# Deploy ke Firebase
Write-Host "Sedang mendeploy ke Firebase..." -ForegroundColor Yellow
firebase deploy --only hosting:shop

Write-Host "--- shop App Selesai Dideploy! ---" -ForegroundColor Green