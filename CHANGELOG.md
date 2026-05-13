# Changelog

## v0.1.8

- Include `priv/bun/package.json` in the published hex package so
  `spellweaver.check` can read and update it on first run. v0.1.7's package
  files were too restrictive and broke this.
- Make `igniter` an `optional: true` dep instead of `only: [:dev, :test]`.
  This lets the `Mix.Tasks.Spellweaver.Install` installer compile properly
  when spellweaver is consumed as a dep in projects that have igniter, so
  `mix igniter.install spellweaver` works.
- The igniter installer now adds spellweaver to the consumer's `mix.exs`
  with `runtime: false` via `dep_opts`.
- Document `runtime: false` in the manual install snippet in the README.
- Add an integration test that runs `mix igniter.new --install spellweaver`
  end-to-end and verifies `mix spellweaver.check` works in the generated
  project.

## v0.1.7 (retired)

- `spellweaver.check` no longer calls `System.halt/1`. It returns `:ok` on
  success and raises `Mix.Error` on failure, so it can be chained inside
  multi-step aliases like nstandard's `check` without silently skipping
  subsequent steps (e.g. `dialyzer`).
- Restrict the published hex package to `priv/.cspell.json` so locally
  installed `priv/bun` artifacts don't get bundled into releases.

## v0.1.5

- Add argument for setting the cspell version.
- Add default cspell version set to 9.4.0 because cspell broke stuff in 9.6.0 and 9.5.0 does not exist.
- Reordered the changelog.
- Renamed module that was for some reason called spellrider.check.ex.

## v0.1.4

Fix an issue where the spellchecking was lying about working.

## v0.1.3

Make bun not drop JS project garbage everywhere.

## v0.1.1

Initial release. Includes an igniter installer to provide a default `.cspell.json` config.
