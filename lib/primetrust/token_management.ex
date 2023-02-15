defmodule PrimeTrust.TokenManagement do
  @moduledoc """
  Responsable for renewing JWT token.
  Every 8 hours by default.

  Can be modified in config

  ```
  config :optimus,
     renew_jwt_time_interval: 3000 # 3 sec.
  ```
  """
  use GenServer, restart: :transient

  require Logger

  def start_link(run_interval) do
    PrimeTrust.Auth.JWT.set_jwt()
    GenServer.start_link(__MODULE__, run_interval, name: __MODULE__)
  end

  @impl true
  def init(run_interval) do
    {:ok, run_interval, {:continue, :schedule_next_run}}
  end

  @impl true
  def handle_continue(:schedule_next_run, run_interval) do
    Process.send_after(self(), :perform_cron_work, run_interval)
    {:noreply, run_interval}
  end

  @impl true
  def handle_info(:perform_cron_work, run_interval) do
    PrimeTrust.Auth.JWT.set_jwt()
    {:noreply, run_interval, {:continue, :schedule_next_run}}
  end
end
