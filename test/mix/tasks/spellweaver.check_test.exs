defmodule Mix.Tasks.Spellweaver.CheckTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO

  @tag :tmp_dir
  test "spelling is bad", %{tmp_dir: dir} do
    File.write!(Path.join(dir, "myfile.txt"), "fnork, bork, dork")

    assert_raise Mix.Error, "Spellcheck failed.", fn ->
      Mix.Tasks.Spellweaver.Check.run([dir])
    end
  end

  @tag :tmp_dir
  test "spelling is fine", %{tmp_dir: dir} do
    File.write!(Path.join(dir, "myfile.txt"), "only, dork")

    assert_raise Mix.Error, "Spellcheck failed.", fn ->
      Mix.Tasks.Spellweaver.Check.run([dir])
    end
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

    assert :ok = Mix.Tasks.Spellweaver.Check.run([dir])
  end

  @tag :tmp_dir
  test "cspell version flag is accepted", %{tmp_dir: dir} do
    File.write!(Path.join(dir, "myfile.txt"), "hello world")

    File.write!(Path.join(dir, ".cspell.json"), """
    {
      "$schema": "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
      "version": "0.2",
      "language": "en",
      "words": []
    }
    """)

    output =
      capture_io(fn ->
        assert :ok = Mix.Tasks.Spellweaver.Check.run(["--cspell-version", "9.2.0", dir])
      end)

    assert output =~ "installed cspell@9.2.0"
  end
end
