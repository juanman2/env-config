# CLAUDE.md — env-config

Shell configuration for zsh. Read this before changing anything here.

## What this replaces, and why nothing was ported forward

`~/src/Env2` was the previous setup: bash/ksh-family (`dot-bashrc`,
`dot-bash-profile`, `dot-aliasrc`, plus a late, minimal `dot-zshrc`
that only set `PATH`), with a naming convention where the real content
lived in undotted `dot-<name>` files and dotted symlinks *inside the
repo* pointed at them (`.bashrc -> dot-bashrc`). That's a different,
more indirect pattern than this repo's — here, `zshrc` (no leading dot,
no in-repo symlink) is the one real file, and `install.sh` symlinks
`~/.zshrc` straight to it, matching `emacs-config`'s `install.sh`.
Don't reintroduce Env2's double-hop style.

Content-wise, `Env2/dot-bashrc` was almost entirely tied to a specific
past job/project (Yugabyte Cloud paths, an OpenCPN sailing-nav build's
LDFLAGS, a hardcoded `PLATFORM_API_KEY` value sitting in plaintext in
git history) — none of it current. Two things from it *are* generically
useful and worth knowing were considered:

- `EDITOR=emacsclient` — the idea is right (this config also settled on
  emacsclient as the daily driver, see `emacs-config`), but the old
  bare form doesn't autostart a daemon if none is running. If this gets
  added here, use `export EDITOR="emacsclient -c -a ''"` — emacsclient's
  own `-a ''` (empty alternate-editor string) means "start `emacs
  --daemon` automatically and retry" — don't reinvent that with a
  polling loop like `emacs-config.sh`'s interactive `emacs()` function
  does; that loop exists there because `-c -n` (non-blocking, for
  interactive use) needs the daemon confirmed *before* returning, which
  `-a` doesn't handle to blocking `$EDITOR` invocations don't need that.
- `git_branch()` + prompt integration — reasonable, but not ported
  speculatively; add it if actually wanted, not because the old config
  had it.

Everything else in `Env2` (GOPATH/BUILDROOT, virtualenvwrapper,
Terraform/JDK paths) was specific to tooling/projects that aren't part
of the current environment. Add language/tool paths here when a
current project actually needs them, not preemptively.

## Conventions

- `zshrc` is the one real file `~/.zshrc` symlinks to. Keep it flat
  (like `emacs-config.sh`) rather than splitting into multiple sourced
  files until it's actually big enough to need that — don't
  pre-emptively modularize.
- This repo is the shell-config hub: it's what `~/.zshrc` actually
  points at, and it `source`s sibling repos' own shell-integration
  files (e.g. `emacs-config/emacs-config.sh`) rather than duplicating
  their content here. A new sibling repo with its own shell needs adds
  one `if [ -e ... ]; then source ...; fi` block here, following that
  same pattern — it doesn't get its content pasted in directly.
- Secrets never get literal values committed to this repo. `secret-add`
  (in `zshrc`) is the only sanctioned way to add one: it prompts for
  the value (hidden input, never a command-line argument, so it never
  lands in shell history) and writes only a `security
  find-generic-password` *lookup* expression to `zshrc` — never the
  value itself.
- No comments explaining *what* a line does — only *why*, when it's
  non-obvious.

## Testing a change

`zsh -n zshrc` catches syntax errors without executing anything.
`install.sh`'s symlink logic can be exercised against a scratch `$HOME`
(`HOME=/tmp/scratch install.sh`) without touching the real `~/.zshrc`.
There's no way to test `secret-add` without writing to the real
Keychain — don't invent a fake keychain to test against; that's more
machinery than the function is worth. Just read it carefully.
