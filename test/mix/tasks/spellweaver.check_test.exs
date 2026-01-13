defmodule Mix.Tasks.Spellweaver.CheckTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO

  @tag :tmp_dir
  test "spelling is bad", %{tmp_dir: dir} do
    File.write!(Path.join(dir, "myfile.txt"), "fnork, bork, dork")

    Process.put(:fake_halt, true)
    assert {1, "Spellcheck failed."} = Mix.Tasks.Spellweaver.Check.run([dir])
  end

  @tag :tmp_dir
  test "spelling is fine", %{tmp_dir: dir} do
    File.write!(Path.join(dir, "myfile.txt"), "only, dork")

    Process.put(:fake_halt, true)
    assert {1, "Spellcheck failed."} = Mix.Tasks.Spellweaver.Check.run([dir])
  end

  @tag :tmp_dir
  test "ignoring bad files works", %{tmp_dir: dir} do
    File.write!(Path.join(dir, "myfile.txt"), "only, dork")
    File.write!(Path.join(dir, "badfile.txt"), "fnork, bork, dork")

    File.write!(Path.join(dir, ".cspell.json"), """
    {
      "$schema": "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
      "version": "0.2",
      "language": "en",
      "ignorePaths": [
        "badfile.txt"
      ],
      "words": []
    }
    """)

    Process.put(:fake_halt, true)

    assert {0, "Spellcheck passed."} = Mix.Tasks.Spellweaver.Check.run([dir])
  end

  @tag :tmp_dir
  test "cspell version flag is accepted", %{tmp_dir: dir} do
    File.write!(Path.join(dir, "myfile.txt"), "only, dork")

    File.write!(Path.join(dir, ".cspell.json"), """
    {
      "$schema": "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
      "version": "0.2",
      "language": "en",
      "words": []
    }
    """)

    Process.put(:fake_halt, true)

    # Should work with version flag before directory and install specified version
    output =
      capture_io(fn ->
        Mix.Tasks.Spellweaver.Check.run(["--cspell-version", "9.2.0", dir])
      end)

    assert output =~ "installed cspell@9.2.0"
  end
end
