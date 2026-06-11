# run_git.ps1

Write-Host "--- Memulai Proses Git ---" -ForegroundColor Cyan

# 1. Menampilkan status file yang berubah
Write-Host "Status perubahan:" -ForegroundColor Yellow
git status

# 2. Menambahkan semua perubahan
Write-Host "Menambahkan file (git add .)..." -ForegroundColor Yellow
git add .

# 3. Meminta pesan commit dari pengguna
$commitMessage = Read-Host "Masukkan pesan commit"

if (-not $commitMessage) {
    Write-Host "Pesan commit tidak boleh kosong! Proses dibatalkan." -ForegroundColor Red
    exit
}

Write-Host "Melakukan commit..." -ForegroundColor Yellow
git commit -m "$commitMessage"

# 4. Melakukan push ke repository
Write-Host "Melakukan push ke remote repository..." -ForegroundColor Yellow
git push

Write-Host "--- Git Process Selesai! ---" -ForegroundColor Green