# -------- Pane Mode (Ctrl-p) --------
bind -n C-p switch-client -T pane-mode

# Navigation
bind -r -T pane-mode h select-pane -L
bind -r -T pane-mode j select-pane -D
bind -r -T pane-mode k select-pane -U
bind -r -T pane-mode l select-pane -R

bind -r -T pane-mode Left  select-pane -L
bind -r -T pane-mode Down  select-pane -D
bind -r -T pane-mode Up    select-pane -U
bind -r -T pane-mode Right select-pane -R

bind -T pane-mode q display-panes
bind -T pane-mode 0 select-pane -t 0
bind -T pane-mode 1 select-pane -t 1
bind -T pane-mode 2 select-pane -t 2
bind -T pane-mode 3 select-pane -t 3
bind -T pane-mode 4 select-pane -t 4
bind -T pane-mode 5 select-pane -t 5
bind -T pane-mode 6 select-pane -t 6
bind -T pane-mode 7 select-pane -t 7
bind -T pane-mode 8 select-pane -t 8
bind -T pane-mode 9 select-pane -t 9

# Resize
bind -r -T pane-mode H resize-pane -L 20
bind -r -T pane-mode J resize-pane -D 7
bind -r -T pane-mode K resize-pane -U 7
bind -r -T pane-mode L resize-pane -R 20

# Swap
bind -r -T pane-mode '[' swap-pane -s '{left-of}'
bind -r -T pane-mode ']' swap-pane -s '{right-of}'
bind -r -T pane-mode '{' swap-pane -U
bind -r -T pane-mode '}' swap-pane -D

bind -T pane-mode z resize-pane -Z  # Zoom
bind -T pane-mode w break-pane      # Convert active pane to window

bind -T pane-mode x confirm-before -p "kill-pane #P? (y/n)" kill-pane

# -------- Window Mode (Ctrl-w) --------
bind -n C-w switch-client -T window-mode

# Navigation
bind -r -T window-mode h select-window -t '{previous}'
bind -r -T window-mode l select-window -t '{next}'

bind -r -T window-mode Left  select-window -t '{previous}'
bind -r -T window-mode Right select-window -t '{next}'

bind -T window-mode 0 select-window -t 0
bind -T window-mode 1 select-window -t 1
bind -T window-mode 2 select-window -t 2
bind -T window-mode 3 select-window -t 3
bind -T window-mode 4 select-window -t 4
bind -T window-mode 5 select-window -t 5
bind -T window-mode 6 select-window -t 6
bind -T window-mode 7 select-window -t 7
bind -T window-mode 8 select-window -t 8
bind -T window-mode 9 select-window -t 9

# Swap
bind -r -T window-mode '[' swap-window -d -t '{previous}'
bind -r -T window-mode ']' swap-window -d -t '{next}'

# Split window
bind -T window-mode '\' split-window -h
bind -T window-mode '|'  split-window -v

bind -T window-mode r command-prompt -I "#W" { rename-window "%%" }
bind -T window-mode n new-window
bind -T window-mode x confirm-before -p "kill-window #W? (y/n)" kill-window
bind -T window-mode w choose-window
bind -T window-mode * setw synchronize-panes

# -------- Session Mode (Ctrl-s) --------
bind -n C-s switch-client -T session-mode

# Rename session
bind -T session-mode r command-prompt -I "#S" { rename-session "%%" }

# Create new session (if session exists, attach to that)
# Functionally equal to switch-session (below)
bind -T session-mode n display-popup \
    -b rounded -w 50 -h 7 -S fg=colour141 -s fg=colour189 \
    -T ' Create New Session (CTRL-C to quit) ' \
    -E 'printf "\033[38;5;141m------------------------------------------------\033[0m\n%s\n" "Session Name:" && read "name?> " && { tmux has-session -t $name 2> /dev/null 2> /dev/null || tmux new-session -d -s $name && tmux switch-client -t $name }' 

# Switch session (if session does not exists, create and attach to that)
# Functionally equal to create-session (above) 
bind -T session-mode s display-popup \
    -b rounded -w 50 -h 7 -S fg=colour141 -s fg=colour189 \
    -T ' Switch Session (CTRL-C to quit) ' \
    -E 'printf "\033[38;5;141m------------------------------------------------\033[0m\n%s\n" "Session Name:" && read "name?> " && { tmux has-session -t $name 2> /dev/null 2> /dev/null || tmux new-session -d -s $name && tmux switch-client -t $name }' 

# Kill session (and attach to any existing session)
set-option -g detach-on-destroy off  # killing session doesn't detach client
bind -T session-mode x confirm-before -p "kill-session #S? (y/n)" kill-session

# -------- Prefix Mode --------
# TODO: give user option to select vi or not
setw -g mode-keys vi
bind -T prefix v copy-mode

# In case user unbinds all keys

bind -T prefix r refresh-client
# TODO: get config file as option
bind -T prefix R run-shell "tmux source-file ~/.config/tmux/tmux.conf > /dev/null; \
    tmux display-message 'Sourced tmux.conf!'"
bind -T prefix d detach
bind -T prefix w choose-window
bind -T prefix : command-prompt
bind -T prefix * setw synchronize-panes

# -------- Copy Mode (VI) --------
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel

