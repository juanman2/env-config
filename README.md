# env-config

Shell configuration (zsh), rewritten 2026-08-12 to replace `~/src/Env2`
— an old bash/ksh-family setup (`dot-bashrc`, `dot-bash-profile`,
`dot-aliasrc`) built for a job/project stack (Yugabyte Cloud, OpenCPN)
that's no longer current. Not migrated forward: this repo starts clean
for zsh rather than carrying that history over. See `CLAUDE.md` for
what was reviewed from it and why nothing was ported.

## Install

```sh
git clone git@github.com:juanman2/env-config.git ~/src/env-config
~/src/env-config/install.sh
```

Symlinks `~/.zshrc` to `zshrc` in this repo — same pattern as
[emacs-config](https://github.com/juanman2/emacs-config)'s
`install.sh`: idempotent, and backs up (never overwrites) anything
unexpected already at `~/.zshrc`.

## secret-add

Saves a value to the macOS Keychain and appends its `export` line to
`zshrc` in one step, so a new API key becomes available in every future
shell without hand-editing anything:

```sh
secret-add SOME_NEW_API_KEY
# prompts for the value (hidden input, never touches shell history)
```

The Keychain service name always matches the env var name (e.g.
`ANTHROPIC_API_KEY`, `DIGITALOCEAN_TOKEN`) — one name to remember, not
two. Re-running it for a name that already exists updates the Keychain
entry (`-U`) rather than erroring, and leaves the `export` line alone
if one's already there instead of duplicating it.
