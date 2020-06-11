defmodule WorldTemp.TempProcessor do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {WorldTemp.CityProducer, []},
        # transformer entry invokes our transform/2 function at the bottom of the module which is
        # required boilerplate to format our incoming messages to a %Broadway.Message{} struct.
        transformer: {__MODULE__, :transform, []},
        rate_limiting: [
          allowed_messages: 60,
          interval: 60_000
        ]
      ],
      processors: [
        # handle_message/3 with a concurrency of 5
        default: [concurrency: 5]
      ]
    )
  end

  @impl true
  def handle_message(:default, message, _context) do
    message
    |> Message.update_data(fn {city, country} ->
      city_data = {city, country, WorldTemp.TempFetcher.fetch_data(city, country)}
      WorldTemp.TempTracker.update_coldest_city(city_data)
    end)
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def ack(:ack_id, _successful, _failed) do
    :ok
  end
end
