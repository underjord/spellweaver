defmodule Mix.Tasks.Spellweaver.Check do
  @moduledoc """
  Check the spelling of the project using cspell.
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
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

    {cspell_version, remaining_args} = extract_cspell_version(args)

    {target_dir, args} =
      case remaining_args do
        [] ->
          {File.cwd!(), []}

        [target_dir | args] ->
          {target_dir, args}
      end

    cspell_args =
      ~w(--bun --cwd=#{working_dir} cspell) ++
        ~w(-r #{target_dir}) ++
        args ++
        [target_dir]

    with 0 <- add(~w(#{cspell_version} --cwd=#{working_dir})),
         :ok <- create_script(working_dir),
         # Options are found here, both docs and --help are lying
         # https://github.com/streetsidesoftware/cspell/tree/main/packages/cspell#options
         0 <-
           run_(cspell_args) do
      halt(0, "Spellcheck passed.")
    else
      status ->
        halt(status, "Spellcheck failed.")
    end
  end

  defp halt(status, message) do
    if Process.get(:fake_halt, false) do
      {status, message}
    else
      if status == 0 do
        Mix.shell().info(message)
      else
        Mix.shell().error(message)
      end

      System.halt(status)
    end
  end

  cond do
    Code.ensure_loaded?(JSON) ->
      defdelegate encode!(data), to: JSON
      defdelegate decode!(data), to: JSON

    Code.ensure_loaded?(Jason) ->
      defdelegate encode!(data), to: Jason
      defdelegate decode!(data), to: Jason
  end

  defp create_script(working_dir) do
    pkg_path = Path.join(working_dir, "package.json")

    new_pkg =
      pkg_path
      |> File.read!()
      |> decode!()
      |> Map.put("scripts", %{"spell" => "node cspell"})
      |> encode!()

    File.write!(pkg_path, new_pkg)
    :ok
  end

  defp extract_cspell_version(args) do
    case OptionParser.parse(args, strict: [cspell_version: :string]) do
      {[cspell_version: version], remaining_args, _errors} ->
        {"cspell@#{version}", remaining_args}

      _ ->
        # We default to 9.4.0 because 9.6.0 is broken at the time of writing
        # and 9.5.0 was never released.
        {"cspell@9.4.0", args}
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
