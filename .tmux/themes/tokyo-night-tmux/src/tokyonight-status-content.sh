#!/usr/bin/env bash

# Tokyo Night theme - Status bar com ícones (Nerd Fonts)
# Usando paleta Tokyo Night

# Verificar se a paleta foi carregada
if [ ${#PALLETE[@]} -eq 0 ]; then
    echo "Warning: Tokyo Night palette not loaded. Colors may not display correctly."
fi

# Obter os formatos de data e hora das variáveis de ambiente do tmux
DATE_FORMAT=$(tmux show-environment -g TOKYONIGHT_TMUX_STATUS_DATE_FORMAT 2>/dev/null | cut -d= -f2-)

# Fallback se as variáveis não existirem
DATE_FORMAT=${DATE_FORMAT:-"%Y-%m-%d"}

#+----------------+
#+ Plugin Support +
#+----------------+
#+--- tmux-prefix-highlight ---+
tmux set -g @prefix_highlight_output_prefix "#[fg=${PALLETE[magenta]}]#[bg=${PALLETE[bg]}]#[nobold]#[noitalics]#[nounderscore]#[bg=${PALLETE[magenta]}]#[fg=${PALLETE[bg]}]"
tmux set -g @prefix_highlight_output_suffix ""
tmux set -g @prefix_highlight_copy_mode_attr "fg=${PALLETE[magenta]},bg=${PALLETE[bg]},bold"

#+--------+
#+ Status +
#+--------+
#+--- Bars ---+
tmux set -g status-left "#[fg=${PALLETE[bg]},bg=${PALLETE[green]},bold] 󰌌 #S #[fg=${PALLETE[green]},bg=${PALLETE[bg]},nobold,noitalics,nounderscore]"
tmux set -g status-right "#{prefix_highlight}#[fg=${PALLETE[bg_highlight]},bg=${PALLETE[bg]},nobold,noitalics,nounderscore]#[fg=${PALLETE[fg]},bg=${PALLETE[bg_highlight]}] 󱧶 #{b:pane_current_path} #[fg=${PALLETE[fg]},bg=${PALLETE[bg_highlight]},nobold,noitalics,nounderscore]#[fg=${PALLETE[fg]},bg=${PALLETE[bg_highlight]}] 󰃭 ${DATE_FORMAT} #[fg=${PALLETE[magenta]},bg=${PALLETE[bg_highlight]},nobold,noitalics,nounderscore]#[fg=${PALLETE[bg]},bg=${PALLETE[magenta]},bold] 󱑼 Artefak "

#+--- Windows ---+
tmux set -g window-status-format "#[fg=${PALLETE[bg]},bg=${PALLETE[bg_highlight]},nobold,noitalics,nounderscore] #[fg=${PALLETE[fg]},bg=${PALLETE[bg_highlight]}]#I #[fg=${PALLETE[fg]},bg=${PALLETE[bg_highlight]},nobold,noitalics,nounderscore] #[fg=${PALLETE[fg]},bg=${PALLETE[bg_highlight]}]#W #F #[fg=${PALLETE[bg_highlight]},bg=${PALLETE[bg]},nobold,noitalics,nounderscore]"
tmux set -g window-status-current-format "#[fg=${PALLETE[bg]},bg=${PALLETE[magenta]},nobold,noitalics,nounderscore] #[fg=${PALLETE[bg]},bg=${PALLETE[magenta]}]#I #[fg=${PALLETE[bg]},bg=${PALLETE[magenta]},nobold,noitalics,nounderscore] #[fg=${PALLETE[bg]},bg=${PALLETE[magenta]}]#W #F #[fg=${PALLETE[magenta]},bg=${PALLETE[bg]},nobold,noitalics,nounderscore]"
tmux set -g window-status-separator ""
