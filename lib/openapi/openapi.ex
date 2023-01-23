defmodule PrimeTrust.OpenApi do
  @moduledoc false

  alias PrimeTrust.OpenApi

  def pipeline(options \\ []) do
    [
      {OpenApi.Phases.Parse, options}
    ]
  end

  def run(pipeline) do
    {:ok, _} =
      pipeline
      |> List.flatten()
      |> run_stage(%OpenApiGen.Blueprint{})
  end

  defp run_stage(pipeline, input)

  defp run_stage([], input) do
    {:ok, input}
  end

  defp run_stage([stage_config | todo], input) do
    {phase, options} = invoke_stage(stage_config)

    case phase.run(input, options) do
      {:ok, result} ->
        run_stage(todo, result)

      {:error, message} ->
        {:error, message}

      _ ->
        {:error, "Stage caused issues"}
    end
  end

  defp invoke_stage({stage, options}) when is_list(options) do
    {stage, options}
  end

  defp invoke_stage(stage) do
    {stage, []}
  end
end
