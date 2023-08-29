eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# NOTE: As part of https://stackoverflow.com/a/38980986 (for the `-xg` flag, see https://stackoverflow.com/a/66843728 and https://fishshell.com/docs/current/language.html#exporting-variables)
set -xg SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# NOTE: Needed for dotnet global tools to work
fish_add_path $HOME/.dotnet/tools
set -xg DOTNET_ROOT /usr/share/dotnet

function mkdircd --argument dir
    mkdir -p -- $dir
    and cd -- $dir
end

if status is-interactive
	# --- Key Bindings:
	# NOTE: https://github.com/fish-shell/fish-shell/issues/4770
	bind \b backward-kill-word # NOTE: Ctrl+Backspace
	bind \e\[3\;5~ kill-word # NOTE: Ctrl+Delete
	# NOTE: Tab is by default mapped to `complete`, we change it to `accept-autosuggestion` and then use `Shift+Tab` for `complete` instead.
	bind \t accept-autosuggestion # NOTE: Tab
	bind \e\[Z complete # NOTE: Shift+Tab

	# --- Abbreviations (i.e. aliases):
	# NOTE: See https://ifconfig.co
	abbr -a getip "curl -s ifconfig.co/json | jq"

	# --- Syntax Colorings:
	# NOTE: See https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables
	set fish_color_command ffcb6b
	set fish_color_keyword ff9b6b
	set fish_color_param normal
	set fish_color_option b2c9cf
	set fish_color_quote d57541
	set fish_color_operator 7f9090
	set fish_color_end 7f9090

	# --- Tab Size:
	tabs 4

	# --- Prompt:
	starship init fish | source
end
