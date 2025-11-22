#!/usr/bin/env bash
set -euo pipefail

# Script ini untuk install paket setelah fresh install EndeavourOS/Arch-based.
# Cara kerja singkat:
# 1) update sistem dengan pacman
# 2) pastikan "base-devel" dan "git" terpasang (diperlukan untuk makepkg)
# 3) jika "yay" tidak ada, akan di-clone dari AUR dan di-build secara otomatis
# 4) semua paket di-array "packages" akan diinstall menggunakan "yay"

# --- Konfigurasi paket ---
packages=(
	"niri"
	"noctalia-shell"
	"alacritty"
	"fuzzel"
	"swaybg"
	"firefox"
	"ttf-jetbrains-mono-nerd"
	"xwayland-satellite"
	"vim"
	"rofi"
	"ghostty"
	"zsh"
	"stow"
	"fzf"
	"discord"
	
	"visual-studio-code-bin"
	"insomnia-bin"
	"podman-compose"
	"podman"
	"nodejs"
	"npm"

	"wireshark-qt"
	"nmap"
	"rustscan"
)

# --- Validasi environment ---
if [ "$(id -u)" -eq 0 ]; then
	echo "Jangan jalankan script ini sebagai root. Jalankan sebagai user biasa (pakai sudo bila diperlukan)."
	exit 1
fi

echo "Mulai: akan menginstall paket-paket yang didefinisikan dalam script ini."

# Update sistem dan install dependency untuk build AUR
echo "1/4: Update sistem (pacman) dan pastikan base-devel/git terpasang..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel git

# Install yay bila belum ada
echo "2/4: Mengecek keberadaan yay..."
if ! command -v yay >/dev/null 2>&1; then
	echo "yay tidak ditemukan. Menginstall yay dari AUR..."
	tmpdir="$(mktemp -d)"
	git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
	(cd "$tmpdir/yay" && makepkg -si --noconfirm)
	rm -rf "$tmpdir"
else
	echo "yay ditemukan: $(command -v yay)"
fi

# Install paket (yay akan menginstall dari repo resmi maupun AUR)
echo "3/4: Menginstall paket-paket dengan yay (akan melewati yang sudah terpasang)..."
yay -S --noconfirm --needed "${packages[@]}"

echo "4/4: Selesai. Periksa output di atas untuk error."

echo "Jika ada paket yang ingin Anda tambahkan atau hapus, edit file ini: /home/karina/dotfiles/install_pkgs.sh"
