# Spellweaver

An Elixir-wrapped spell checker for code.

This library takes Bun as a runtime, downloads cspell and uses it to check the
spelling in your Elixir code. Intended for CI usage.

## Installation

Install using igniter to also get offered a default `.cspell.json` config:

```sh
mix archive.install hex igniter_new
mix igniter.install spellweaver
```

Or manually by adding `spellweaver` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spellweaver, "~> 0.1.0"}
  ]
end
```

## Usage

Run the spell checker:

```sh
mix spellweaver.check
```

### Pinning cspell Version

For CI environments, you can pin a specific cspell version using the `--cspell-version` flag:

```sh
mix spellweaver.check --cspell-version 9.4.0
```

This ensures consistent spell checking across builds and prevents breaking changes from new cspell releases.

Example CI configuration (GitHub Actions):

```yaml
- name: Run spell checker
  run: mix spellweaver.check --cspell-version 9.4.0
```
