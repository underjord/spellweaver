defmodule Mix.Tasks.Spellweaver.InstallTest do
  use ExUnit.Case, async: true
  import Igniter.Test

  test "it warns when run" do
    cspell_config =
      :spellweaver
      |> :code.priv_dir()
      |> Path.join(".cspell.json")
      |> File.read!()

    test_project()
    |> Igniter.compose_task("spellweaver.install", [])
    |> Igniter.Test.assert_creates(".cspell.json", cspell_config)
  end
end
