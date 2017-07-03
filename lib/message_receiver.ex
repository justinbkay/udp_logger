defmodule AcmeUdpLogger.MessageReceiver do
  use GenServer
  #require Logger
  alias AcmeUdpLogger.MessageParser

  @doc ~S"""
  Collects incoming udp packets and sends them into a worker pool for parsing
  and saving to a database

  """

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    opts = [:binary, active: true]
    {:ok, _socket} = :gen_udp.open(21337, opts)
  end

  def handle_info({:udp, socket, ip, port, data}, state) do
    #IO.puts "Incoming data:"
    #IO.inspect(data, limit: :infinity)

    #AcmeUdpLogger.FileWriter.write_file(data)
    #_message = MessageParser.parse_packet(data, socket, ip, port)
    # Logger.info "Received a message! " <> inspect(message, limit: :infinity)
   :poolboy.transaction(:message_parser_pool, fn(worker) ->
      MessageParser.parse_packet(worker, data, socket, ip, port)
    end)

    {:noreply, state}
  end

  def handle_info({_, _socket}, state) do
    {:noreply, state}
  end

end
