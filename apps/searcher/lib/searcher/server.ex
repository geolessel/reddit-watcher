defmodule Searcher.Server do
  use GenServer
  require Logger
  import Ecto.Query

  @interval 60_000 * 5 # five minutes
  @retry_interval 30_000

  # ┌────────────┐
  # │ Client API │
  # └────────────┘

  def start_link(_opts \\ []) do
    case (Searcher.Search |> first |> Searcher.Repo.one) do
      nil ->
        {:stop, "No searches set up"}
      %{term: _term, subreddit: _subreddit, interval_minutes: _interval_minutes} = result ->
        GenServer.start_link(__MODULE__, result, name: __MODULE__)
    end
  end

  def titles do
    GenServer.cast(__MODULE__, :titles)
  end

  def run do
    GenServer.cast(__MODULE__, :run)
  end

  def stop do
    GenServer.call(__MODULE__, :stop)
  end

  # ┌──────────────────┐
  # │ Server Callbacks │
  # └──────────────────┘

  def init(state) do
    __MODULE__.run
    {:ok, Map.put(state, :timer, nil)}
  end

  def handle_call(:stop, _, %{timer: timer}) do
    {:reply, Process.cancel_timer(timer), nil}
  end

  def handle_cast(:run, %{term: term, subreddit: subreddit, interval_minutes: interval} = state) do
    interval =
      case Searcher.search(subreddit, term) do
        {:ok, response} ->
          Logger.debug "Response OK"
          response
          |> Map.get(:body)
          |> Searcher.deep_get(["data", "children"])
          |> Enum.each(fn(child) ->
            child
            |> Map.get("data")
            |> Searcher.Post.insert_new()
            |> case do
              {:ok, post} ->
                Logger.debug "NEW POST!"
                WatcherWeb.Endpoint.broadcast!("posts", "new-post", post)
              {:existing, _post} -> nil
            end
          end)
          interval * 60_000
        {:error, _response} ->
          Logger.debug "Response error"
          @retry_interval
      end
    timer = Process.send_after(__MODULE__, :run, interval)
    {:noreply, %{state | timer: timer}}
  end

  def handle_cast(:titles, state) do
    Logger.debug "Getting titles"
    case Searcher.search("mechmarket", "ergodox", 10) do
      {:ok, response} ->
        Logger.debug "response OK"
        titles =
          response
          |> Map.get(:body)
          |> Searcher.titles()
        Logger.info Enum.join(titles, " ||| ")
      {:error, _response} ->
        Logger.debug "error from response"
    end
    {:noreply, state}
  end

  def handle_info(:run, state) do
    GenServer.cast(__MODULE__, :run)
    {:noreply, state}
  end
  
  # def handle_call(msg, {from, ref}, state) do
  #   # {:reply, reply, state}
  #   # {:reply, reply, state, timeout}
  #   # {:reply, reply, state, :hibernate}
  #   # {:noreply, state}
  #   # {:noreply, state, timeout}
  #   # {:noreply, state, :hibernate}
  #   # {:stop, reason, reply, state}
  #   # {:stop, reason, state}
  # end
  # 
  # def handle_cast(msg, state) do
  #   # {:noreply, state}
  #   # {:noreply, state, timeout}
  #   # {:noreply, state, :hibernate}
  # end
  # 
  # def handle_info(msg, state) do
  #   # {:noreply, state}
  #   # {:noreply, state, timeout}
  #   # {:stop, reason, state}
  # end
  # 
  # def terminate(reason, state) do
  #   :ok
  # end


  # ┌──────────────────┐
  # │ Helper Functions │
  # └──────────────────┘
end
