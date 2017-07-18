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

  def record_packet(144, message, header, packet) do
    %AcmeUdpLogger.Packet144{
      options_byte: header.options_byte,
      mobile_id_length: header.mobile_id_length,
      mobile_id: header.mobile_id,
      mobile_id_type: header.mobile_id_type,
      service_type: header.service_type,
      message_type: header.message_type,
      sequence: header.sequence,
      update_time: convert_datetime(header.update_time),
      time_of_fix: convert_datetime(header.time_of_fix),
      latitude: Float.to_string(header.latitude),
      longitude: Float.to_string(header.longitude),
      altitude: convert_centimeters_to_feet(header.altitude),
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
      map_id: message.map_id,
      jpod_mach_state: message.jpod_mach_state,
      map_id_rev_con: message.map_id_rev_con,
      odometer_length: message.odometer_length,
      odometer_1708: message.odometer_1708,
      odometer_1939: message.odometer_1939,
      odometer_hi_rez: message.odometer_hi_rez,
      batt_volt_1708: message.batt_volt_1708,
      batt_volt_1939: message.batt_volt_1939,
      sw_batt_volt_1708: message.sw_batt_volt_1708,
      sw_batt_volt_1939: message.sw_batt_volt_1939,
      engine_speed_1708: message.engine_speed_1708,
      engine_speed_1939: message.engine_speed_1939,
      wheel_based_speed: message.wheel_based_speed,
      parking_brake: message.parking_brake,
      brake_pedal_switch_1708: message.brake_pedal_switch_1708,
      cruze_control_spd: message.cruze_control_spd,
      eng_coolant_tmp_1708: message.eng_coolant_tmp_1708,
      eng_coolant_tmp_1939: message.eng_coolant_tmp_1939,
      eng_coolant_pres_1708: message.eng_coolant_pres_1708,
      eng_coolant_pres_1939: message.eng_coolant_pres_1939,
      eng_coolant_lvl_1708: message.eng_coolant_lvl_1708,
      eng_coolant_lvl_1939: message.eng_coolant_lvl_1939,
      eng_oil_tmp_1708: message.eng_oil_tmp_1708,
      eng_oil_tmp_1939: message.eng_oil_tmp_1939,
      eng_oil_pres_1708: message.eng_oil_pres_1708,
      eng_oil_pres_1939: message.eng_oil_pres_1939,
      eng_crank_pres_1708: message.eng_crank_pres_1708,
      eng_crank_pres_1939: message.eng_crank_pres_1939,
      eng_oil_lvl_1708: message.eng_oil_lvl_1708,
      eng_oil_lvl_1939: message.eng_oil_lvl_1939,
      eng_fuel_lvl_1_1708: message.eng_fuel_lvl_1_1708,
      eng_fuel_lvl_1_1939: message.eng_fuel_lvl_1_1939,
      eng_fuel_lvl_2_1708: message.eng_fuel_lvl_2_1708,
      eng_fuel_lvl_2_1939: message.eng_fuel_lvl_2_1939,
      seatbelt_switch: message.seatbelt_switch,
      eng_inst_fuel_econ_1708: message.eng_inst_fuel_econ_1708,
      eng_inst_fuel_econ_1939: message.eng_inst_fuel_econ_1939,
      eng_fuel_rate_1708: message.eng_fuel_rate_1708,
      eng_fuel_rate_1939: message.eng_fuel_rate_1939,
      hi_rez_eng_fuel_rate_1939: message.hi_rez_eng_fuel_rate_1939,
      transmission_gear_1939: message.transmission_gear_1939,
      accel_pedal_position_1708: message.accel_pedal_position_1708,
      accel_pedal_position_1939: message.accel_pedal_position_1939,
      brake_pedal_position_1939: message.brake_pedal_position_1939,
      turn_signal: message.turn_signal,
      transmission_curr_range_1939: message.transmission_curr_range_1939,
      percent_eng_load_1939: message.percent_eng_load_1939,
      percent_eng_torque_1939: message.percent_eng_torque_1939,
      def_tank_lvl_1939: message.def_tank_lvl_1939,
      raw_packet: packet,
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
