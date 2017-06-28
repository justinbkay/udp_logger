defmodule AcmeUdpLogger.FileWriter do
  
  def write_file(data) do
    {:ok, file} = File.open "packet.bin", [:write]
    IO.binwrite file, data
    File.close file
  end

end
