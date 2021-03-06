defmodule AcmeUdpLogger.Repo.Migrations.CreatePacket1 do
  use Ecto.Migration

  def change do
    create table(:packet1) do
      add :mobile_id, :string
      add :service_type, :integer
      add :message_type, :integer
      add :update_time, :utc_datetime
      add :time_of_fix, :utc_datetime
      add :latitude, :string
      add :longitude, :string
      add :altitude, :integer
      add :speed, :integer
      add :heading, :integer
      add :satellites, :integer
      add :fix_status, :integer
      add :carrier, :integer
      add :rssi, :integer
      add :comm_state, :integer
      add :hdop, :integer
      add :inputs, :integer
      add :unit_status, :integer
      add :event_index, :integer
      add :event_code, :string
      add :accums, :integer
      add :spare, :integer
      add :accum_list, :binary
      timestamps
    end
  end
end
