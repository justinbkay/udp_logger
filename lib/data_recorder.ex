defmodule AcmeUdpLogger.DataRecorder do

  def record_packet(2, message, data) do
    %AcmeUdpLogger.Packet1{mobile_id: message.mobile_id,
    service_type: message.service_type,
    message_type: message.message_type,
    update_time: convert_datetime(message.update_time),
    time_of_fix: convert_datetime(message.time_of_fix),
    speed: message.speed,
    latitude: Float.to_string(message.latitude),
    longitude: Float.to_string(message.longitude),
    altitude: message.altitude,
    heading: message.heading,
    satellites: message.satellites,
    fix_status: message.fix_status,
    carrier: message.carrier,
    rssi: message.rssi,
    comm_state: message.comm_state,
    hdop: message.hdop,
    inputs: message.inputs,
    event_index: message.event_index,
    event_code: event_name(message.event_code),
    accums: message.accums,
    spare: message.spare,
    inserted_at: Ecto.DateTime.utc } |> AcmeUdpLogger.Repo.insert
  end
  
  def convert_datetime(dt) do
    {:ok, datetime} = DateTime.from_unix(dt)
    datetime
    |> DateTime.to_naive
    |> NaiveDateTime.to_erl
    |> Ecto.DateTime.from_erl
  end
  
  defp event_name(code) do
    case code do
      0 ->
        "Power Up"
      11 ->
        "Ignition Switch On"
      111 ->
        "Engine On"
      12 ->
        "Ignition Switch Off"
      112 ->
        "Engine Off"
      9 ->
        "Time Distance Report (30 sec interval) between ignition on and off"
      10 ->
        "Time Distance Report (heading change) between ignition on and off"
      17 ->
        "Ignition Off (1 Hour report interval)"
    end
  end
end
