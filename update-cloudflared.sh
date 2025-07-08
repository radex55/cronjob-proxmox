#!/bin/bash

# Nama file sementara
TMP_DEB="/tmp/cloudflared.deb"

echo "🚀 Memulai update cloudflared..."

# Unduh versi terbaru dari GitHub
echo "📥 Mengunduh cloudflared versi terbaru..."
wget -O "$TMP_DEB" https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb

# Cek apakah unduhan berhasil
if [ $? -ne 0 ]; then
  echo "❌ Gagal mengunduh file. Periksa koneksi internet atau URL."
  exit 1
fi

# Install paket .deb
echo "📦 Menginstal cloudflared..."
sudo dpkg -i "$TMP_DEB"

# Cek status instalasi
if [ $? -eq 0 ]; then
  echo "✅ cloudflared berhasil diperbarui ke versi:"
  cloudflared --version
else
  echo "❌ Instalasi gagal. Coba periksa dependency atau gunakan 'sudo apt --fix-broken install'"
fi

# Hapus file sementara
rm -f "$TMP_DEB"

#Jadikan executable: chmod +x update-cloudflared.sh
#cara run: ./update-cloudflared.sh
#cronjob :> buat aja sendiri.
