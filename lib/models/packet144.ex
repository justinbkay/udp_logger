defmodule AcmeUdpLogger.Packet144 do
  use Ecto.Schema

  schema "packet144" do
    field :options_byte, :integer
    field :mobile_id_length, :integer
    field :mobile_id, :string
    field :mobile_id_type_length, :integer
    field :mobile_id_type, :integer
    field :service_type, :integer
    field :message_type, :integer
    field :sequence, :integer
    field :update_time, Ecto.DateTime
    field :time_of_fix, Ecto.DateTime
    field :latitude, :string
    field :longitude, :string
    field :altitude, :integer
    field :speed, :integer
    field :heading, :integer
    field :satellites, :integer
    field :fix_status, :integer
    field :carrier, :integer
    field :rssi, :integer
    field :comm_state, :integer
    field :hdop, :integer
    field :inputs, :integer
    field :unit_status, :integer
    field :app_msg_type, :integer
    field :app_msg_len, :integer
    field :map_id, :integer
    field :jpod_mach_state, :integer
    field :map_id_rev_con, :integer
    field :odometer_length, :integer
    field :odometer_1708, :float
    field :odometer_1939, :float
    field :odometer_hi_rez, :float
    field :batt_volt_1708, :float
    field :batt_volt_1939, :float
    field :sw_batt_volt_1708, :float
    field :sw_batt_volt_1939, :float
    field :engine_speed_1708, :float
    field :engine_speed_1939, :float
    field :wheel_based_speed, :float
    field :parking_brake, :integer
    field :brake_pedal_switch_1708, :integer
    field :cruze_control_spd, :integer
    field :eng_coolant_tmp_1708, :float
    field :eng_coolant_tmp_1939, :float
    field :eng_coolant_pres_1708, :float
    field :eng_coolant_pres_1939, :float
    field :eng_coolant_lvl_1708, :float
    field :eng_coolant_lvl_1939, :float
    field :eng_oil_tmp_1708, :float
    field :eng_oil_tmp_1939, :float
    field :eng_oil_pres_1708, :float
    field :eng_oil_pres_1939, :float
    field :eng_crank_pres_1708, :float
    field :eng_crank_pres_1939, :float
    field :eng_oil_lvl_1708, :float
    field :eng_oil_lvl_1939, :float
    field :eng_fuel_lvl_1_1708, :float
    field :eng_fuel_lvl_1_1939, :float
    field :eng_fuel_lvl_2_1708, :float
    field :eng_fuel_lvl_2_1939, :float
    field :seatbelt_switch, :integer
    field :eng_inst_fuel_econ_1708, :float
    field :eng_inst_fuel_econ_1939, :float
    field :eng_fuel_rate_1708, :float
    field :eng_fuel_rate_1939, :float
    field :hi_rez_eng_fuel_rate_1939, :float
    field :transmission_gear_1939, :integer
    field :accel_pedal_position_1708, :float
    field :accel_pedal_position_1939, :float
    field :brake_pedal_position_1939, :float
    field :turn_signal, :integer
    field :transmission_curr_range_1939, :integer
    field :percent_eng_load_1939, :float
    field :percent_eng_torque_1939, :float
    field :def_tank_lvl_1939, :float
    field :inserted_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
  end
end
