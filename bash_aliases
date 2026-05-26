# Fungsi untuk membatalkan semua perubahan lokal Git dan abort rebase jika ada
nah() {
    local RE_CLR="\033[0m"
    local INFO_CLR="\033[1;34m"
    local SUCC_CLR="\033[1;32m"
    local ERR_CLR="\033[1;31m"

    # 1. Validasi: Pastikan perintah dijalankan di dalam direktori kerja Git
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${ERR_CLR}[ERROR]${RE_CLR} Direktori saat ini bukan repositori Git."
        return 1
    fi

    echo -e "${INFO_CLR}[INFO]${RE_CLR} Mengembalikan repositori ke commit terakhir..."

    # 2. Reset paksa semua file yang dilacak ke HEAD
    git reset --hard HEAD

    # 3. Reset submodul jika projek Anda menggunakannya (opsional tapi sangat aman)
    if git submodule status &>/dev/null; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Menyinkronkan dan mereset submodul Git..."
        git submodule update --init --recursive --force
    fi

    # 4. Hapus file/folder tidak dilacak (termasuk yang diabaikan oleh .gitignore jika menggunakan -x)
    echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan file yang tidak dilacak..."
    git clean -dfx

    # 5. Deteksi otomatis dan batalkan proses rebase atau merge yang menggantung
    if [[ -d ".git/rebase-apply" || -d ".git/rebase-merge" ]] || git status 2>/dev/null | grep -E -q "rebase|merge"; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Mendeteksi proses rebase/merge aktif. Membatalkan..."
        git rebase --abort 2>/dev/null || true
        git merge --abort 2>/dev/null || true
    fi

    echo -e "${SUCC_CLR}[OK]${RE_CLR} Repositori Git berhasil dikembalikan ke kondisi bersih (HEAD)."
}


# Fungsi untuk membersihkan cache paket sistem, manajer paket, dan file sementara
clean() {
    local RE_CLR="\033[0m"
    local INFO_CLR="\033[1;34m"
    local SUCC_CLR="\033[1;32m"
    local WARN_CLR="\033[1;33m"

    # 1. Membersihkan cache APT jika perintah 'apt' tersedia
    if command -v apt &> /dev/null; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan cache paket APT..."
        apt clean
        apt autoclean
        apt autoremove --purge -y
    fi

    # 2. Membersihkan cache Composer jika tersedia
    if command -v composer &> /dev/null; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan cache Composer..."
        composer clear-cache
    fi

    # 3. Membersihkan cache NPM jika tersedia
    if command -v npm &> /dev/null; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan cache Node (NPM)..."
        npm cache clean --force
    fi

    # 4 Membersihkan cache Cargo (Rust) jika tersedia
    if [ -d "${HOME}/.cargo" ]; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan cache Cargo (Rust)..."
        if command -v cargo-cache &> /dev/null; then
            # Menggunakan tools resmi jika terinstal
            cargo cache --trim
        else
            # Menggunakan penghapusan manual yang aman jika tools tidak ada
            [[ -d "${HOME}/.cargo/registry/cache" ]] && find "${HOME}/.cargo/registry/cache" -mindepth 1 -delete 2>/dev/null || true
            [[ -d "${HOME}/.cargo/registry/src" ]] && find "${HOME}/.cargo/registry/src" -mindepth 1 -delete 2>/dev/null || true
            [[ -d "${HOME}/.cargo/git" ]] && find "${HOME}/.cargo/git" -mindepth 1 -delete 2>/dev/null || true
        fi
    fi

    # Membersihkan cache Go (Golang) jika perintah 'go' tersedia
    if command -v go &> /dev/null; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan cache Go (Build & Modcache)..."
        # Menghapus build cache dan module cache menggunakan internal tool Go yang aman
        go clean -cache -modcache -testcache 2>/dev/null || true
    fi

    # 5. Membersihkan cache pengguna secara aman (menghindari rm -rf /*)
    echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan direktori cache pengguna..."
    if [[ -d "${HOME}/.cache" ]]; then
        find "${HOME}/.cache" -mindepth 1 -delete 2>/dev/null || true
    fi
    # Untuk multi-user Linux (lewati jika di Termux)
    if [[ -d "/home" && "$PREFIX" != *com.termux* ]]; then
        find /home/*/ .cache/ -mindepth 1 -delete 2>/dev/null || true
    fi

    # 6. Membersihkan cache internal Termux jika berada di lingkungan Termux
    if [[ -d "/data/data/com.termux/cache" ]]; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan cache aplikasi Termux..."
        find /data/data/com.termux/cache -mindepth 1 -delete 2>/dev/null || true
    fi

    # 7. Membersihkan file sementara (Temporary Files)
    echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan file sementara..."
    local tmp_dirs=("/tmp" "/var/tmp")
    [[ -n "${PREFIX:-}" ]] && tmp_dirs+=("${PREFIX}/tmp")

    for dir in "${tmp_dirs[@]}"; do
        if [[ -d "${dir}" ]]; then
            # Menggunakan find -delete jauh lebih aman daripada rm -rf /*
            find "${dir}" -mindepth 1 -delete 2>/dev/null || true
        fi
    done

    # 8. Membersihkan Riwayat Terminal (History)
    echo -e "${INFO_CLR}[INFO]${RE_CLR} Membersihkan riwayat Bash..."
    if [[ -f "${HOME}/.bash_history" ]]; then
        rm -f "${HOME}/.bash_history"
        history -c  # Mengosongkan history sesi berjalan saat ini
    fi

    echo -e "${SUCC_CLR}[OK]${RE_CLR} Semua proses pembersihan selesai."
}

# Fungsi untuk membersihkan total lingkungan kerja Neovim, Intelephense, dan Go
viret() {
    local RE_CLR="\033[0m"
    local INFO_CLR="\033[1;34m"
    local SUCC_CLR="\033[1;32m"

    local targets=(
        "${HOME}/intelephense"
        "${HOME}/.local/share/nvim"
        "${HOME}/.local/state/nvim"
    )

    echo -e "${INFO_CLR}[INFO]${RE_CLR} Memulai pembersihan lingkungan dev (Viret)..."

    # Pembersihan cache utama terlebih dahulu
    if [[ -d "${HOME}/.cache" ]]; then
        find "${HOME}/.cache" -mindepth 1 -delete 2>/dev/null || true
    fi

    # Hapus direktori target nvim & intelephense jika ada
    for target in "${targets[@]}"; do
        if [[ -d "${target}" || -f "${target}" ]]; then
            echo -e "${INFO_CLR}[INFO]${RE_CLR} Menghapus: ${target}"
            rm -rf "${target}"
        fi
    done

    # Penanganan folder .go secara aman
    if [[ -d "${HOME}/.go" ]]; then
        echo -e "${INFO_CLR}[INFO]${RE_CLR} Mengatur ulang izin dan menghapus: ${HOME}/.go"
        # Berikan izin tulis sebelum dihapus untuk menghindari error "Permission Denied" pada module Go
        chmod -R 700 "${HOME}/.go"
        rm -rf "${HOME}/.go"
    fi

    echo -e "${SUCC_CLR}[OK]${RE_CLR} Pembersihan lingkungan dev selesai."
}

# Fungsi untuk membersihkan konfigurasi & cache lingkungan (Termux/Linux)
cleanx11() {
    # Definisi warna untuk output terminal
    local RE_CLR="\033[0m"
    local INFO_CLR="\033[1;34m"
    local SUCC_CLR="\033[1;32m"
    local WARN_CLR="\033[1;33m"

    # Daftar target yang akan dihapus (relatif terhadap $HOME)
    local TARGETS=(
        ".BurpSuite"
        ".ICEauthority"
        ".cpan"
        ".dbus"
        ".java"
        "Desktop"
        ".config/Thunar"
        ".config/dconf"
        ".config/gtk-3.0"
        ".config/pulse"
        ".config/wireshark"
        ".local/share/gvfs-metadata"
        ".local/share/recently-used.xbel"
    )

    echo -e "${INFO_CLR}[INFO]${RE_CLR} Memulai proses pembersihan lingkungan..."
    local deleted_count=0

    for item in "${TARGETS[@]}"; do
        # Bangun path absolut secara aman
        local full_path="${HOME}/${item}"

        # Validasi keamanan: Cegah penghapusan root atau HOME itu sendiri
        if [[ -z "${item}" || "${full_path}" == "/" || "${full_path}" == "${HOME}" ]]; then
            echo -e "${WARN_CLR}[WARN]${RE_CLR} Target berbahaya dilewati: ${full_path}"
            continue
        fi

        # Periksa apakah file, folder, atau symlink ada
        if [[ -e "${full_path}" || -L "${full_path}" ]]; then
            echo -e "${INFO_CLR}[INFO]${RE_CLR} Menghapus: ${full_path}"

            if rm -rf "${full_path}"; then
                ((deleted_count++))
            else
                echo -e "${WARN_CLR}[WARN]${RE_CLR} Gagal menghapus: ${full_path}"
            fi
        fi
    done

    echo -e "${SUCC_CLR}[OK]${RE_CLR} Selesai. Total ${deleted_count} item berhasil dibersihkan."
}

alias aptup='apt update && apt full-upgrade'
alias root='pd sh termux-docker --isolated --bind $HOME/workspaces:$HOME --bind $HOME/programming:$HOME/code'
alias toor='pd sh debian --isolated --bind $HOME/workspaces:/root --bind $HOME/programming:/root/code'

alias gi='git init'
alias ga='git add'
alias gs='git status'
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias gf='git fetch'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push -u origin main'

alias serve='composer run dev'
alias comp='composer'
alias art='php artisan'
alias oll='ollama serve'
