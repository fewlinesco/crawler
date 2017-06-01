defmodule Crawlers.Children do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      supervisor(Crawler.Supervisor, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_child(supervisor_pid, root_url, fetchers_count, name) do
    Supervisor.start_child(supervisor_pid, [root_url, fetchers_count, [name: name]])
  end
end
