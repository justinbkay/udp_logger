defmodule AcmeUdpLogger do
  use Application
  alias AcmeUdpLogger.MessageParser

  defp poolboy_config do
    [{:name, {:local, :message_parser_pool}},
      {:worker_module, MessageParser},
      {:size, 5},
      {:max_overflow, 5}]
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(AcmeUdpLogger.MessageReceiver, []),
      supervisor(AcmeUdpLogger.Repo, []),
      :poolboy.child_spec(:message_parser_pool, poolboy_config, [])
    ]

    opts = [strategy: :one_for_one, name: AcmeUdpLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
