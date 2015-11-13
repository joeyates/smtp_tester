defmodule Mix.Tasks.SmtpTester.Encode do
  use Mix.Task

  @shortdoc "Encode a username and password for use with SMTP AUTH"

  def run(args) do
    {options, remaining, _invalid} = OptionParser.parse(
      args,
      strict: [
        password: :string,
        username: :string
      ]
    )

    if !options[:username] do
      raise "Supply a --username=x.y.x parameter"
    end

    if !options[:password] do
      raise "Supply a --password=x.y.x parameter"
    end

    <<0>> <> options[:username] <> <<0>> <> options[:password]
    |> :base64.encode_to_string()
    |> IO.puts
  end
end
