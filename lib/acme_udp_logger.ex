defmodule AcmeUdpLogger do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(AcmeUdpLogger.MessageReceiver, []),
      supervisor(AcmeUdpLogger.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: AcmeUdpLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
