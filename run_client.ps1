Write-Host "--- Memulai Build & Deploy client App ---" -ForegroundColor Cyan

# Pindah ke direktori aplikasi
Set-Location -Path "apps/client_app"

# Melakukan build dengan optimasi penuh
# --release: Memastikan mode release (tercepat & terkecil)
# --web-renderer canvaskit: Memberikan performa grafis terbaik
Write-Host "Sedang melakukan build web (release mode)..." -ForegroundColor Yellow
flutter build web --release --web-renderer canvaskit

# Kembali ke root
Set-Location -Path "../../"

# Deploy ke Firebase
Write-Host "Sedang mendeploy ke Firebase..." -ForegroundColor Yellow
firebase deploy --only hosting:client

Write-Host "--- client App Selesai Dideploy! ---" -ForegroundColor Green