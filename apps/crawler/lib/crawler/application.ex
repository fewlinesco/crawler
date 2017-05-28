defmodule Crawler.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Crawlers.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Crawler.Application]
    Supervisor.start_link(children, opts)
  end
end
