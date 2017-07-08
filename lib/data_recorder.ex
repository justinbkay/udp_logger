defmodule AcmeUdpLogger.DataRecorder do

  def record_packet(2, message, data) do
    %AcmeUdpLogger.Packet1{raw_packet: data,
    service_type: message.service_type,
    message_type: message.message_type,
    update_time: DateTime.from_unix(message.update_time),
    time_of_fix: DateTime.from_unix(message.time_of_fix),
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
    event_code: message.event_code,
    accums: message.accums,
    spare: message.spare,
    inserted_at: Ecto.DateTime.utc } |> AcmeUdpLogger.Repo.insert
  end

end
