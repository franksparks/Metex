defmodule Metex.Worker do
  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get() |> parse_response

    case result do
      {:ok, temp} ->
        "#{location}: #{temp}ºC."

      :error ->
        "#{location} not found."
    end
  end

  def url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&APPID=#{apikey()}"
  end

  def parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode() |> compute_temperature
  end

  def parse_response(_) do
    :error
  end

  def compute_temperature(json) do
    IO.puts("compute_temp")

    try do
      temp = json["main"]["temp"] |> IO.inspect(label: "WHAT IS THIS?") |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  def apikey do
    "e745eae4765b7fdd7841f9980f413f09"
  end
end
