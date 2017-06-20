defmodule AcmeUdpLoggerTest do
  use ExUnit.Case
  doctest AcmeUdpLogger

  @header <<83, 05, 01, 02, 03, 04, 05, 01, 01>>
  @service_type <<01>>
  @message_type <<02>>
  @update_time <<0x4F, 0xB4, 0x64, 0x88>>
  @time_fix <<0x4F, 0xB4, 0x64, 0x88>>
  @latitude <<0x13, 0xBF, 0x71, 0xA8>>
  @longitude <<0xBA, 0x18, 0xA5, 0x06>>
  @altitude <<00, 00, 13, 33>>
  @speed <<00, 00, 00, 00>>
  @heading <<11, 11>>
  @satellites <<02>>
  @fix_status <<33>>
  @carrier <<44, 44>>
  @rssi <<55, 55>>
  @comm_state <<66>>
  @hdop <<77>>
  @inputs <<88>>
  @unit_status <<99>>
  @event_index <<10>>
  @event_code <<11>>
  @accums <<01>>
  @spare <<00>>
  @accum_list <<00>>

  test "it should extract relevant data from UDP packet" do
  packet = @header <> @service_type <> @message_type <> @update_time <> @time_fix <> @latitude <> @longitude <> @altitude <> @speed <> @heading <> @satellites <> @fix_status <> @carrier <> @rssi <> @comm_state <> @hdop <> @inputs <> @unit_status <> @event_index <> @event_code <> @accums <> @spare <> @accum_list

  message = AcmeUdpLogger.MessageReceiver.parse_packet(packet)
  assert message
  assert message.update_time == 1337222280
  assert message.time_of_fix == 1337222280
  assert message.latitude /  10000000.0 == 33.1313576
  assert message.longitude / 10000000.0 == -117.2790010
  assert message.altitude == 3361
  assert message.speed == 0
  assert message.heading == 2827
  assert message.satellites == 2
  assert message.fix_status == 33
  assert message.carrier == 11308
  assert message.rssi == 14135
  assert message.service_type == 1
  assert message.message_type == 2
  assert message.comm_state == 66
  assert message.hdop == 77
  assert message.unit_status == 99
  assert message.event_index == 10
  assert message.event_code == 11
  assert message.accums == 1
  assert message.spare == 0
  assert message.accum_list == <<0>>
  assert message.inputs == 88

  end
end
