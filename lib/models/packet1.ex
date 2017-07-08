defmodule AcmeUdpLogger.Packet1 do
  use Ecto.Schema

  schema "packet1" do
    field :raw_packet, :binary
    field :service_type, :integer
    field :message_type, :integer
    field :update_time, :integer
    field :time_of_fix, :integer
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
    field :event_index, :integer
    field :event_code, :integer
    field :accums, :integer
    field :spare, :integer
    field :accum_list, :binary
    field :inserted_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
  end
end
