defmodule GSearcher.Search.KeywordSearcher do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :ok
  end

  @impl true
  def handle_cast({:search, _keyword}, _state) do
  end
end
