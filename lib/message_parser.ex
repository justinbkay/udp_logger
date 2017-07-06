defmodule AcmeUdpLogger.MessageParser do
  use GenServer
  require Logger

  @doc ~S"""
  Receives udp packets and parses them for inserting into a database

  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], [])
  end

  # API
  @doc ~S"""
  The api call to parse the packets.  It invokes the parse header method with
  the binary, socket, ip, and port

  """

  def parse_packet(server, bin, socket, ip, port) do
    GenServer.call(server, {:parse_header, bin, socket, ip, port})
  end

  # Callbacks

  @doc ~S"""
  This method parses the header and either finishes up on a message type 2
  or calls other methods to parse the body of the other message types
  """
  def handle_call({:parse_header, <<
    options_byte          :: unsigned-integer-size(8),
    mobile_id_length      :: unsigned-integer-size(8),
    mobile_id             :: bitstring-size(24),
    mobile_id_type_length :: unsigned-integer-size(8),
    mobile_id_type        :: unsigned-integer-size(8),
    service_type          :: unsigned-integer-size(8),
    message_type          :: unsigned-integer-size(8),
    sequence              :: unsigned-integer-size(16),
    update_time           :: unsigned-integer-size(32),
    time_of_fix           :: unsigned-integer-size(32),
    latitude              :: signed-integer-size(32),
    longitude             :: signed-integer-size(32),
    altitude              :: signed-integer-size(32),
    speed                 :: unsigned-integer-size(32),
    heading               :: unsigned-integer-size(16),
    satellites            :: unsigned-integer-size(8),
    fix_status            :: unsigned-integer-size(8),
    carrier               :: unsigned-integer-size(16),
    rssi                  :: signed-integer-size(16),
    comm_state            :: unsigned-integer-size(8),
    hdop                  :: unsigned-integer-size(8),
    inputs                :: unsigned-integer-size(8),
    unit_status           :: unsigned-integer-size(8),
    event_index           :: unsigned-integer-size(8),
    event_code            :: unsigned-integer-size(8),
    accums                :: unsigned-integer-size(8),
    spare                 :: unsigned-integer-size(8)
    >>, socket, ip, port}, _from, state) do

    IO.puts "message type 2 parsed"
    message = %{
      options_byte: options_byte,
      mobile_id_length: mobile_id_length,
      mobile_id: Base.encode16(mobile_id),
      mobile_id_type_length: mobile_id_type_length,
      mobile_id_type: mobile_id_type,
      service_type: service_type,
      message_type: message_type,
      sequence: sequence,
      update_time: update_time,
      time_of_fix: time_of_fix,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      speed: speed,
      heading: heading,
      satellites: satellites,
      fix_status: fix_status,
      carrier: carrier,
      rssi: rssi,
      comm_state: comm_state,
      hdop: hdop,
      inputs: inputs,
      unit_status: unit_status,
      event_index: event_index,
      event_code: event_code,
      accums: accums,
      spare: spare
    }

    #record_packet(2, message, data)
    send_ack(socket, ip, port, message)
    {:reply, message, state}
  end

  @doc ~S"""
  This method parses the header and either finishes up on a message type 2
  or calls other methods to parse the body of the other message types
  parse_packet method parses all the message types that are not type 2
  """

  def handle_call({:parse_header, <<
    options_byte                 :: unsigned-integer-size(8),
    mobile_id_length             :: unsigned-integer-size(8),
    mobile_id                    :: bitstring-size(24),
    mobile_id_type_length        :: unsigned-integer-size(8),
    mobile_id_type               :: unsigned-integer-size(8),
    service_type                 :: unsigned-integer-size(8),
    message_type                 :: unsigned-integer-size(8),
    sequence                     :: unsigned-integer-size(16),
    update_time                  :: unsigned-integer-size(32),
    time_of_fix                  :: unsigned-integer-size(32),
    latitude                     :: signed-integer-size(32),
    longitude                    :: signed-integer-size(32),
    altitude                     :: signed-integer-size(32),
    speed                        :: unsigned-integer-size(32),
    heading                      :: unsigned-integer-size(16),
    satellites                   :: unsigned-integer-size(8),
    fix_status                   :: unsigned-integer-size(8),
    carrier                      :: unsigned-integer-size(16),
    rssi                         :: signed-integer-size(16),
    comm_state                   :: unsigned-integer-size(8),
    hdop                         :: unsigned-integer-size(8),
    inputs                       :: unsigned-integer-size(8),
    unit_status                  :: unsigned-integer-size(8),
    app_msg_type                 :: unsigned-integer-size(16),
    app_msg_len                  :: unsigned-integer-size(16),
    body         	               :: binary
    >> = packet, socket, ip, port}, _from, state) do

    header = %{
      options_byte: options_byte,
      mobile_id_length: mobile_id_length,
      mobile_id: Base.encode16(mobile_id),
      mobile_id_type_length: mobile_id_type_length,
      mobile_id_type: mobile_id_type,
      service_type: service_type,
      message_type: message_type,
      sequence: sequence,
      update_time: update_time,
      time_of_fix: time_of_fix,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      speed: speed,
      heading: heading,
      satellites: satellites,
      fix_status: fix_status,
      carrier: carrier,
      rssi: rssi,
      comm_state: comm_state,
      hdop: hdop,
      inputs: inputs,
      unit_status: unit_status,
      app_msg_type: app_msg_type,
      app_msg_len: app_msg_len
    }

    Logger.info "Received a packet! " <> inspect(packet, limit: :infinity)
    Logger.info "Received a body! " <> inspect(body, limit: :infinity)

    GenServer.cast(self(), {:parse_packet, body})
    send_ack(socket, ip, port, header)

    {:reply, header, state}
  end

  @doc ~S"""
  This method parses the body of the message for insertion into a database.
  This is for message type 144
  """

  def handle_cast({:parse_packet, <<
    map_id                       :: unsigned-little-integer-size(8),
    jpod_mach_state              :: unsigned-little-integer-size(16),
    map_id_rev_con               :: unsigned-little-integer-size(8),
    odometer_length              :: unsigned-little-integer-size(8),
    odometer_1708                :: unsigned-little-integer-size(32),
    odometer_1939                :: unsigned-little-integer-size(32),
    odometer_hi_rez              :: unsigned-little-integer-size(32),
    batt_volt_1708               :: unsigned-little-integer-size(16),
    batt_volt_1939               :: unsigned-little-integer-size(16),
    sw_batt_volt_1708            :: unsigned-little-integer-size(16),
    sw_batt_volt_1939            :: unsigned-little-integer-size(16),
    engine_speed_1708            :: unsigned-little-integer-size(16),
    engine_speed_1939            :: unsigned-little-integer-size(16),
    wheel_based_speed            :: unsigned-little-integer-size(8),
    parking_brake                :: unsigned-little-integer-size(8),
    brake_pedal_switch_1708      :: unsigned-little-integer-size(8),
    cruze_control_spd            :: unsigned-little-integer-size(64),
    eng_coolant_tmp_1708         :: unsigned-little-integer-size(8),
    eng_coolant_tmp_1939         :: unsigned-little-integer-size(8),
    eng_coolant_pres_1708        :: unsigned-little-integer-size(8),
    eng_coolant_pres_1939        :: unsigned-little-integer-size(8),
    eng_coolant_lvl_1708         :: unsigned-little-integer-size(8),
    eng_coolant_lvl_1939         :: unsigned-little-integer-size(8),
    eng_oil_tmp_1708             :: unsigned-little-integer-size(16),
    eng_oil_tmp_1939             :: unsigned-little-integer-size(16),
    eng_oil_pres_1708            :: unsigned-little-integer-size(8),
    eng_oil_pres_1939            :: unsigned-little-integer-size(8),
    eng_crank_pres_1708          :: unsigned-little-integer-size(8),
    eng_crank_pres_1939          :: unsigned-little-integer-size(16),
    eng_oil_lvl_1708             :: unsigned-little-integer-size(8),
    eng_oil_lvl_1939             :: unsigned-little-integer-size(8),
    eng_fuel_lvl_1_1708          :: unsigned-little-integer-size(8),
    eng_fuel_lvl_1_1939          :: unsigned-little-integer-size(8),
    eng_fuel_lvl_2_1708          :: unsigned-little-integer-size(8),
    eng_fuel_lvl_2_1939          :: unsigned-little-integer-size(8),
    seatbelt_switch              :: unsigned-little-integer-size(8),
    eng_inst_fuel_econ_1708      :: unsigned-little-integer-size(16),
    eng_inst_fuel_econ_1939      :: unsigned-little-integer-size(16),
    eng_fuel_rate_1708           :: unsigned-little-integer-size(16),
    eng_fuel_rate_1939           :: unsigned-little-integer-size(16),
    hi_rez_eng_fuel_rate_1939    :: unsigned-little-integer-size(32),
    transmission_gear_1939       :: unsigned-little-integer-size(8),
    accel_pedal_position_1708    :: unsigned-little-integer-size(8),
    accel_pedal_position_1939    :: unsigned-little-integer-size(8),
    brake_pedal_position_1939    :: unsigned-little-integer-size(8),
    turn_signal                  :: unsigned-little-integer-size(8),
    transmission_curr_range_1939 :: unsigned-little-integer-size(16),
    percent_eng_load_1939        :: unsigned-little-integer-size(8),
    percent_eng_torque_1939      :: unsigned-little-integer-size(8),
    def_tank_lvl_1939            :: unsigned-little-integer-size(8)
    >> = _packet}, state) do

    #IO.inspect(Base.encode16(packet), limit: :infinity)
    IO.puts "parsed 144"
    message = %{
      map_id: map_id,
      jpod_mach_state: jpod_mach_state,
      map_id_rev_con: map_id_rev_con,
      odometer_length: odometer_length,
      odometer_1708: odometer_1708,
      odometer_1939: odometer_1939,
      odometer_hi_rez: odometer_hi_rez,
      batt_volt_1708: batt_volt_1708,
      batt_volt_1939: batt_volt_1939,
      sw_batt_volt_1708: sw_batt_volt_1708,
      sw_batt_volt_1939: sw_batt_volt_1939,
      engine_speed_1708: engine_speed_1708,
      engine_speed_1939: engine_speed_1939,
      wheel_based_speed: wheel_based_speed,
      parking_brake: parking_brake,
      brake_pedal_switch_1708: brake_pedal_switch_1708,
      cruze_control_spd: cruze_control_spd,
      eng_coolant_tmp_1708: eng_coolant_tmp_1708,
      eng_coolant_tmp_1939: eng_coolant_tmp_1939,
      eng_coolant_pres_1708: eng_coolant_pres_1708,
      eng_coolant_pres_1939: eng_coolant_pres_1939,
      eng_coolant_lvl_1708: eng_coolant_lvl_1708,
      eng_coolant_lvl_1939: eng_coolant_lvl_1939,
      eng_oil_tmp_1708: eng_oil_tmp_1708,
      eng_oil_tmp_1939: eng_oil_tmp_1939,
      eng_oil_pres_1708: eng_oil_pres_1708,
      eng_oil_pres_1939: eng_oil_pres_1939,
      eng_crank_pres_1708: eng_crank_pres_1708,
      eng_crank_pres_1939: eng_crank_pres_1939,
      eng_oil_lvl_1708: eng_oil_lvl_1708,
      eng_oil_lvl_1939: eng_oil_lvl_1939,
      eng_fuel_lvl_1_1708: eng_fuel_lvl_1_1708,
      eng_fuel_lvl_1_1939: eng_fuel_lvl_1_1939,
      eng_fuel_lvl_2_1708: eng_fuel_lvl_2_1708,
      eng_fuel_lvl_2_1939: eng_fuel_lvl_2_1939,
      seatbelt_switch: seatbelt_switch,
      eng_inst_fuel_econ_1708: eng_inst_fuel_econ_1708,
      eng_inst_fuel_econ_1939: eng_inst_fuel_econ_1939,
      eng_fuel_rate_1708: eng_fuel_rate_1708,
      eng_fuel_rate_1939: eng_fuel_rate_1939,
      hi_rez_eng_fuel_rate_1939: hi_rez_eng_fuel_rate_1939,
      transmission_gear_1939: transmission_gear_1939,
      accel_pedal_position_1708: accel_pedal_position_1708,
      accel_pedal_position_1939: accel_pedal_position_1939,
      brake_pedal_position_1939: brake_pedal_position_1939,
      turn_signal: turn_signal,
      transmission_curr_range_1939: transmission_curr_range_1939,
      percent_eng_load_1939: percent_eng_load_1939,
      percent_eng_torque_1939: percent_eng_torque_1939,
      def_tank_lvl_1939: def_tank_lvl_1939
    }
    Logger.info inspect(message, limit: :infinity)

    {:noreply, state}
  end

  @doc ~S"""
  This method parses the body of the message for insertion into a database.
  This is for message type 145
  """

  def handle_cast({:parse_packet, <<
    map_id                     :: unsigned-little-integer-size(8),
    jpod_mach_state            :: unsigned-little-integer-size(16),
    map_id_rev_con             :: unsigned-little-integer-size(8),
    spare                      :: unsigned-little-integer-size(8),
    trip_odom_1708             :: unsigned-little-integer-size(32),
    trip_odom_1939             :: unsigned-little-integer-size(32),
    hi_rez_trip_odom_1939      :: unsigned-little-integer-size(32),
    trip_fuel_consumption_1708 :: unsigned-little-integer-size(16),
    trip_fuel_consumption_1939 :: unsigned-little-integer-size(32),
    hi_rez_trip_fuel_1939      :: unsigned-little-integer-size(32)
    >>}, state) do

    IO.puts "mapID 145 parsed"
    message = %{
      map_id: map_id,
      jpod_mach_state: jpod_mach_state,
      map_id_rev_con: map_id_rev_con,
      spare: spare,
      trip_odom_1708: trip_odom_1708,
      trip_odom_1939: trip_odom_1939,
      hi_rez_trip_odom_1939: hi_rez_trip_odom_1939,
      trip_fuel_consumption_1708: trip_fuel_consumption_1708,
      trip_fuel_consumption_1939: trip_fuel_consumption_1939,
      hi_rez_trip_fuel_1939: hi_rez_trip_fuel_1939
    }

    Logger.info inspect(message, limit: :infinity)

    {:noreply, state}
  end

  @doc ~S"""
  This method parses the body of the message for insertion into a database.
  This is for message type 146
  """

  def handle_cast({:parse_packet, <<
    map_id                 :: unsigned-little-integer-size(8),
    jpod_mach_state        :: unsigned-little-integer-size(16),
    map_id_rev_con         :: unsigned-little-integer-size(8),
    spare                  :: unsigned-little-integer-size(8),
    eng_ttl_fuel_used_1708 :: unsigned-little-integer-size(40),
    eng_ttl_fuel_used_1939 :: unsigned-little-integer-size(32),
    hi_rez_ttl_fuel_1939   :: unsigned-little-integer-size(32),
    eng_ttl_idle_fuel_1708 :: unsigned-little-integer-size(32),
    eng_ttl_idle_fuel_1939 :: unsigned-little-integer-size(32),
    eng_ttl_idle_hrs_1708  :: unsigned-little-integer-size(40),
    eng_ttl_idle_hrs_1939  :: unsigned-little-integer-size(32),
    eng_ttl_hrs_1708       :: unsigned-little-integer-size(40),
    eng_ttl_hrs_1939       :: unsigned-little-integer-size(32),
    total_vehicle_hrs_1708 :: unsigned-little-integer-size(40),
    total_vehicle_hrs_1939 :: unsigned-little-integer-size(32),
    total_pto_hours_1708   :: unsigned-little-integer-size(40),
    total_pto_hours_1939   :: unsigned-little-integer-size(32),
    eng_avg_fuel_eco_1708  :: unsigned-little-integer-size(16),
    eng_avg_fuel_eco_1939  :: unsigned-little-integer-size(16)
    >>}, state) do

    IO.puts "mapID 146 parsed"
    message = %{
      map_id: map_id,
      jpod_mach_state: jpod_mach_state,
      map_id_rev_con: map_id_rev_con,
      spare: spare,
      eng_ttl_fuel_used_1708: eng_ttl_fuel_used_1708,
      eng_ttl_fuel_used_1939: eng_ttl_fuel_used_1939,
      hi_rez_ttl_fuel_1939: hi_rez_ttl_fuel_1939,
      eng_ttl_idle_fuel_1708: eng_ttl_idle_fuel_1708,
      eng_ttl_idle_fuel_1939: eng_ttl_idle_fuel_1939,
      eng_ttl_idle_hrs_1708: eng_ttl_idle_hrs_1708,
      eng_ttl_idle_hrs_1939: eng_ttl_idle_hrs_1939,
      eng_ttl_hrs_1708: eng_ttl_hrs_1708,
      eng_ttl_hrs_1939: eng_ttl_hrs_1939,
      total_vehicle_hrs_1708: total_vehicle_hrs_1708,
      total_vehicle_hrs_1939: total_vehicle_hrs_1939,
      total_pto_hours_1708: total_pto_hours_1708,
      total_pto_hours_1939: total_pto_hours_1939,
      eng_avg_fuel_eco_1708: eng_avg_fuel_eco_1708,
      eng_avg_fuel_eco_1939: eng_avg_fuel_eco_1939
    }

    Logger.info inspect(message, limit: :infinity)

    {:noreply, state}
  end

  @doc ~S"""
  This method parses the body of the message for insertion into a database.
  This is for message type 148
  """

  def handle_cast({:parse_packet, <<
    map_id                :: unsigned-little-integer-size(8),
    jpod_mach_state       :: unsigned-little-integer-size(16),
    map_id_rev_con        :: unsigned-little-integer-size(8),
    _spare                :: unsigned-little-integer-size(8),
    vin_1708              :: bitstring-size(136),
    vin_indicator         :: unsigned-little-integer-size(8)
    >>}, state) do

    IO.puts "mapID 148 parsed"
    message = %{
      map_id: map_id,
      jpod_mach_state: jpod_mach_state,
      map_id_rev_con: map_id_rev_con,
      vin: vin_1708,
      vin_indicator: vin_indicator
    }

    Logger.info inspect(message, limit: :infinity)
    {:noreply, state}
  end

  @doc ~S"""
  This method parses the body of the message but doesn't do anything with it.
  This is for message type 151
  """

  def handle_cast({:parse_packet, <<
    <<151>>,
    _rest    :: binary
    >>}, state) do

    IO.puts "mapID 151 parsed"
    message = %{
    }

    Logger.info inspect(message, limit: :infinity)
    {:noreply, state}
  end

  @doc ~S"""
  This method parses the body of the message but doesn't do anything with it.
  This is for message type 152
  """

  def handle_cast({:parse_packet, <<
    <<152>>,
    _rest    :: binary
    >>}, state) do

    IO.puts "mapID 152 parsed"
    message = %{
    }

    Logger.info inspect(message, limit: :infinity)

    {:noreply, state}
  end

  # Helper methods
  def send_ack(socket, ip, port, message) do
    packet = <<131>> <>
    one_byte(message.mobile_id_length) <>
    decode_hex(message.mobile_id) <>
    one_byte(message.mobile_id_type_length) <>
    one_byte(message.mobile_id_type) <>
    <<02>> <>
    <<01>> <>
    two_bytes(message.sequence) <>
    one_byte(2) <>
    one_byte(0) <>
    one_byte(0) <>
    three_bytes(0)

    #IO.inspect(Base.encode16(packet), limit: :infinity)
    :gen_udp.send(socket, ip, port, packet)
  end

  def decode_hex(string) do
    {:ok, binstring} = Base.decode16(string)
    binstring
  end

  def one_byte(number) do
    << _x :: 8>> = << number :: 8>>
  end

  def three_bytes(number) do
    << _x :: 24>> = << number :: 24>>
  end

  def two_bytes(number) do
    << _x :: 16 >> = << number :: 16 >>
  end

end
