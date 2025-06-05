defmodule Mix.Tasks.Spellweaver.InstallTest do
  use ExUnit.Case, async: true
  import Igniter.Test

  test "it warns when run" do
    # generate a test project
    test_project()
    # run our task
    |> Igniter.compose_task("spellweaver.install", [])
    # see tools in `Igniter.Test` for available assertions & helpers
    |> assert_has_warning("mix spellweaver.install is not yet implemented")
  end
end
