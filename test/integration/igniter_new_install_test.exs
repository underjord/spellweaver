defmodule Spellweaver.Integration.IgniterNewInstallTest do
  use ExUnit.Case, async: false

  @moduletag :integration
  @moduletag timeout: :timer.minutes(5)

  @tag :tmp_dir
  test "fresh project created via igniter.new --install spellweaver runs spellweaver.check", %{
    tmp_dir: tmp_dir
  } do
    spellweaver_root = File.cwd!()
    proj_name = "spellweaver_integration_test"

    {new_out, new_status} =
      System.cmd(
        "mix",
        [
          "igniter.new",
          proj_name,
          "--install",
          "spellweaver@path:#{spellweaver_root}",
          "--yes",
          "--no-git"
        ],
        cd: tmp_dir,
        stderr_to_stdout: true,
        env: [{"MIX_ENV", "dev"}]
      )

    assert new_status == 0, "mix igniter.new failed:\n#{new_out}"

    proj_dir = Path.join(tmp_dir, proj_name)
    mix_exs = File.read!(Path.join(proj_dir, "mix.exs"))

    assert mix_exs =~ ~r/\{:spellweaver,[^}]*runtime: false/,
           "spellweaver dep not added with runtime: false:\n#{mix_exs}"

    assert File.exists?(Path.join(proj_dir, ".cspell.json")),
           "expected .cspell.json to be generated"

    target_dir = Path.join(proj_dir, "spell_target")
    File.mkdir_p!(target_dir)
    File.write!(Path.join(target_dir, "myfile.txt"), "this is a simple sentence\n")

    File.write!(Path.join(target_dir, ".cspell.json"), """
    {
      "$schema": "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
      "version": "0.2",
      "language": "en",
      "words": []
    }
    """)

    {check_out, check_status} =
      System.cmd(
        "mix",
        ["spellweaver.check", target_dir],
        cd: proj_dir,
        stderr_to_stdout: true,
        env: [{"MIX_ENV", "dev"}]
      )

    assert check_status == 0, "mix spellweaver.check failed:\n#{check_out}"
    assert check_out =~ "Spellcheck passed."
  end
end
