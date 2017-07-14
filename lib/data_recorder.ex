defmodule AcmeUdpLogger.DataRecorder do

  def record_packet(2, message) do
    %AcmeUdpLogger.Packet1{mobile_id: message.mobile_id,
    service_type: message.service_type,
    message_type: message.message_type,
    update_time: convert_datetime(message.update_time),
    time_of_fix: convert_datetime(message.time_of_fix),
    speed: convert_centimeters_to_miles(message.speed),
    latitude: Float.to_string(message.latitude),
    longitude: Float.to_string(message.longitude),
    altitude: convert_centimeters_to_feet(message.altitude),
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

  def record_packet(144, message, header) do
    %AcmeUdpLogger.Packet144{
      options_byte: header.options_byte,
      mobile_id_length: header.mobile_id_length,
      mobile_id: header.mobile_id,
      mobile_id_type: header.mobile_id_type,
      service_type: header.service_type,
      message_type: header.message_type,
      sequence: header.sequence,
      update_time: header.update_time,
      time_of_fix: header.time_of_fix,
      latitude: header.latitude,
      longitude: header.longitude,
      altitude: header.altitude,
      speed: header.speed,
      heading: header.heading,
      satellites: header.satellites,
      fix_status: header.fix_status,
      carrier: header.carrier,
      rssi: header.rssi,
      comm_state: header.comm_state,
      hdop: header.hdop,
      inputs: header.inputs,
      unit_status: header.unit_status,
      app_msg_type: header.app_msg_type,
      app_msg_len: header.app_msg_len,
      inserted_at: Ecto.DateTime.utc } |> AcmeUdpLogger.Repo.insert
  end

  defp convert_centimeters_to_miles(centimeters) do
    round(centimeters * 0.0000062137)
  end

  defp convert_centimeters_to_feet(centimeters) do
    round(centimeters / 30.48)
  end

  defp convert_datetime(dt) do
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
