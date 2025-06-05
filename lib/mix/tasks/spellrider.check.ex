defmodule Mix.Tasks.Spellweaver.Check do
  @moduledoc """
  Check the spelling of the project using cspell.
  """

  use Mix.Task

  def run(_args) do
    config = [
      args: ~w(),
      cd: Path.expand("."),
      env: %{}
    ]

    Application.put_env(:bun, :spellweaver, config)

    Application.get_all_env(:bun) |> IO.inspect()

    with 0 <- Bun.run(:spellweaver, ~w(add cspell)),
         0 <- Bun.run(:spellweaver, ~w(run cspell . --quiet)) do
      Mix.shell().info("Spellcheck passed.")
    else
      status ->
        Mix.shell().error("Spellcheck failed.")
        System.halt(status)
    end
  end
end
