#!/usr/bin/env bash

# Copyright (c) 2025 - Tokyo Night theme for tmux

TOKYONIGHT_TMUX_PALETTES_FILE=src/palletes/night.sh
TOKYONIGHT_TMUX_COLOR_THEME_FILE=src/tokyonight.sh
TOKYONIGHT_TMUX_VERSION=1.0.0
TOKYONIGHT_TMUX_STATUS_CONTENT_FILE="src/tokyonight-status-content.sh"
TOKYONIGHT_TMUX_STATUS_CONTENT_OPTION="@tokyonight_show_status_content"
TOKYONIGHT_TMUX_STATUS_CONTENT_DATE_FORMAT="@tokyonight_date_format"
_current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

__cleanup() {
    unset -v TOKYONIGHT_TMUX_PALETTES_FILE TOKYONIGHT_TMUX_COLOR_THEME_FILE TOKYONIGHT_TMUX_VERSION
    unset -v TOKYONIGHT_TMUX_STATUS_CONTENT_FILE
    unset -v TOKYONIGHT_TMUX_STATUS_CONTENT_OPTION
    unset -v TOKYONIGHT_TMUX_STATUS_CONTENT_DATE_FORMAT
    unset -v _current_dir
    unset -f __load __cleanup __setup_time_date_formats
    # tmux set-environment -gu TOKYONIGHT_TMUX_STATUS_DATE_FORMAT
}

__setup_time_date_formats() {
    local date_format=$(tmux show-option -gqv "$TOKYONIGHT_TMUX_STATUS_CONTENT_DATE_FORMAT")

    # Configurar formato de data
    if [ -z "$date_format" ]; then
        tmux set-environment -g TOKYONIGHT_TMUX_STATUS_DATE_FORMAT "%Y-%m-%d"
    else
        tmux set-environment -g TOKYONIGHT_TMUX_STATUS_DATE_FORMAT "$date_format"
    fi
}

__load() {
    # 1. Carregar paletas de cores primeiro (se existir)
    if [ -f "$_current_dir/$TOKYONIGHT_TMUX_PALETTES_FILE" ]; then
        echo "Loading Tokyo Night color palette..."
        source "$_current_dir/$TOKYONIGHT_TMUX_PALETTES_FILE"
    else
        echo "Warning: Palette file not found at $_current_dir/$TOKYONIGHT_TMUX_PALETTES_FILE"
    fi

    # 2. Carregar configurações de tema base
    if [ -f "$_current_dir/$TOKYONIGHT_TMUX_COLOR_THEME_FILE" ]; then
        echo "Loading Tokyo Night base theme..."
        source "$_current_dir/$TOKYONIGHT_TMUX_COLOR_THEME_FILE"
    else
        echo "Warning: Theme file not found at $_current_dir/$TOKYONIGHT_TMUX_COLOR_THEME_FILE"
    fi

    # 3. Configurar formatos de data e hora
    __setup_time_date_formats

    # 4. Carregar configurações de status bar (se habilitado)
    local status_content=$(tmux show-option -gqv "$TOKYONIGHT_TMUX_STATUS_CONTENT_OPTION")

    if [ "$status_content" != "0" ]; then
        if [ -f "$_current_dir/$TOKYONIGHT_TMUX_STATUS_CONTENT_FILE" ]; then
            echo "Loading Tokyo Night status bar (with icons)..."
            source "$_current_dir/$TOKYONIGHT_TMUX_STATUS_CONTENT_FILE"
        else
            echo "Warning: Status content file not found at $_current_dir/$TOKYONIGHT_TMUX_STATUS_CONTENT_FILE"
        fi
    fi
    echo "Tokyo Night theme loaded successfully!"
}

__load
__cleanup
