export PATH="$HOME/.local/bin:$PATH"

#===
alias aiform-venv="source /Users/juan/src/aiform/.venv/bin/activate"
alias python3.12="/opt/homebrew/bin/python3.12"

# Anthropic
export ANTHROPIC_API_KEY=$(security find-generic-password -a "juan" -s "ANTHROPIC_API_KEY" -w)

# secret-add: save a value in the macOS Keychain and wire up its export
# line here, so a new API key becomes available in every future shell
# without hand-editing this file. Service name in Keychain always
# matches the env var name (e.g. ANTHROPIC_API_KEY above, added by hand
# before this function existed) -- keeps one name to remember instead
# of two, and avoids a lookup layer between the two.
secret-add() {
  if [ -z "$1" ]; then
    echo "usage: secret-add ENV_VAR_NAME" >&2
    return 1
  fi
  local name="$1" value
  read -rs "value?Value for $name (input hidden): "
  echo
  if [ -z "$value" ]; then
    echo "secret-add: empty value, aborting" >&2
    return 1
  fi
  # -U: update in place if this service/account pair already exists,
  # so re-running rotates a key instead of erroring out.
  if ! security add-generic-password -s "$name" -a "$USER" -U -w "$value"; then
    echo "secret-add: failed to write to Keychain" >&2
    return 1
  fi
  unset value

  local rcfile="$HOME/src/env-config/zshrc"
  local exportline="export $name=\$(security find-generic-password -s \"$name\" -a \"\$USER\" -w)"
  if grep -q "^export $name=" "$rcfile" 2>/dev/null; then
    echo "secret-add: $name already exported in $rcfile, left as-is"
  else
    printf '\n# %s\n%s\n' "$name (added via secret-add)" "$exportline" >> "$rcfile"
    echo "secret-add: appended export for $name to $rcfile"
  fi
  echo "secret-add: run 'exec zsh' or open a new shell to pick it up"
}

# Emacs shell integration (daemon launcher, vterm cwd tracking) lives
# in the emacs-config repo, not here.
if [ -e ~/src/emacs-config/emacs-config.sh ]; then
  source ~/src/emacs-config/emacs-config.sh
fi
