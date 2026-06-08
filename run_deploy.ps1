# run_deploy.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   MATRIXSPHERE DEPLOYMENT MANAGER      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Pilih target deploy:"
Write-Host "1) [Main/All]  Deploy semua site"
Write-Host "2) [Admin]     Deploy ke admin-sphere"
Write-Host "3) [Client]    Deploy ke client-sph"
Write-Host "4) [Shop]      Deploy ke shop-sph"
Write-Host "========================================" -ForegroundColor Cyan

$pilihan = Read-Host "Masukkan nomor pilihan (1-4)"

switch ($pilihan) {
    "1" {
        Write-Host "Mendeploy SEMUA aplikasi..." -ForegroundColor Yellow
        firebase deploy --only hosting
    }
    "2" {
        Write-Host "Mendeploy Admin App..." -ForegroundColor Yellow
        # Sesuaikan folder jika perlu
        Set-Location -Path "apps/admin_app"
        flutter build web --release
        Set-Location -Path "../../"
        firebase deploy --only hosting:admin
    }
    "3" {
        Write-Host "Mendeploy Client App..." -ForegroundColor Yellow
        Set-Location -Path "apps/client_app"
        flutter build web --release
        Set-Location -Path "../../"
        firebase deploy --only hosting:client
    }
    "4" {
        Write-Host "Mendeploy Shop App..." -ForegroundColor Yellow
        Set-Location -Path "apps/shop_app"
        flutter build web --release
        Set-Location -Path "../../"
        firebase deploy --only hosting:shop
    }
    Default {
        Write-Host "Pilihan tidak valid!" -ForegroundColor Red
        exit
    }
}

Write-Host "--- Deployment Selesai! ---" -ForegroundColor Green