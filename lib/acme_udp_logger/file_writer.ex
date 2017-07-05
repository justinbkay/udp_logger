defmodule AcmeUdpLogger.FileWriter do

  def write_file(data) do
    {:ok, file} = File.open "failure_log.txt", [:write]
    IO.puts file, Base.encode16(data)
    File.close file
  end

end
