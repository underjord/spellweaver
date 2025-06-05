defmodule Mix.Tasks.Spellweaver.Check do
  @moduledoc """
  Check the spelling of the project using cspell.
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    config = [
      args: ~w(),
      cd: Path.expand("."),
      env: %{}
    ]

    Application.put_env(:bun, :spellweaver, config)

    :ok = Bun.install()

    working_dir =
      :code.priv_dir(:spellweaver)
      |> Path.join("bun")

    File.mkdir_p(working_dir)

    current_dir = File.cwd!()

    cspell_path =
      working_dir
      |> Path.join("node_modules/cspell/dist/esm/app.mjs")

    with 0 <- add(~w(cspell --cwd=#{working_dir})),
         0 <- run_(~w(#{cspell_path} #{current_dir} --quiet --cwd=#{working_dir})) do
      Mix.shell().info("Spellcheck passed.")
    else
      status ->
        Mix.shell().error("Spellcheck failed.")
        System.halt(status)
    end
  end

  defp add(args) do
    bun("add", args)
  end

  defp run_(args) do
    bun("run", args)
  end

  defp bun(command, args) do
    Bun.run(:spellweaver, [command | args])
  end
end
