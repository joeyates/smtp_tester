defmodule Mix.Tasks.SmtpTester.Send do
  use Mix.Task

  @shortdoc "Try to send an email"

  """
  Content can be supplied as a parameter or in a file via the --file= parameter
  """

  def run(args) do
    {options, remaining, _invalid} = OptionParser.parse(
      args,
      strict: [
        server: :string,
        password: :string,
        username: :string,
        file: :string,
        from: :string,
        to: :string,
        subject: :string,
      ],
      aliases: [p: :password, s: :server, u: :username]
    )

    if !options[:server] do
      raise "Supply a --server=x.y.x parameter"
    end

    configuration = [{:relay, options[:server]}]

    if options[:username] do
      configuration = [{:username, :erlang.bitstring_to_list(options[:username])} | configuration]

      if options[:password] do
        configuration = [{:password, :erlang.bitstring_to_list(options[:password])} | configuration]
      end
    end

    if options[:from] do
      from = options[:from]
    else
      raise "Supply a --from=me@example.com parameter"
    end

    if options[:to] do
      to = options[:to]
    else
      raise "Supply a --to=foo@example.com parameter"
    end

    if options[:file] do
      {:ok, message} = File.read(options[:file])
    else
      message = Enum.join(remaining, "\r\n")
    end

    if message == "" do
      message = "Test"
    end

    if options[:subject] do
      message = "Subject: " <> options[:subject] <> "\r\n" <> message
    end

    response = :gen_smtp_client.send_blocking(
      {from, [to], message }, configuration
    )
    case response do
      {:error, reason, status} ->
        IO.puts "Error #{reason}: #{inspect(status, [pretty: true])}"
      _ ->
        IO.puts response
    end
  end
end
