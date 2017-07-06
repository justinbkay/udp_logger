defmodule AcmeUdpLogger.FileWriter do

  def write_file(data, header) do
    {:ok, file} = File.open "failure_log.txt", [:write]
    IO.puts file, Base.encode16(data)
    IO.puts file, IO.inspect(header)
    File.close file
  end

end
