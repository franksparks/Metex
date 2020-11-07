defmodule Metex.Worker do
  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})

      _ ->
        IO.puts("Don't know how to process this message.")
    end

    loop
  end

  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get() |> parse_response

    case(result) do
      {:ok, name, temp, temp_min, temp_max, humidity} ->
        "Ciudad: #{name} /-/
        Temperatura actual: #{temp}°C /-/
        Mínima: #{temp_min}°C /-/
        Máxima: #{temp_max}°C
        Humedad: #{humidity}%."

      :error ->
        "#{location} not found."
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode!() |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      name = json["name"]
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      temp_min = (json["main"]["temp_min"] - 273.15) |> Float.round(1)
      temp_max = (json["main"]["temp_max"] - 273.15) |> Float.round(1)
      humidity = json["main"]["humidity"]

      {:ok, name, temp, temp_min, temp_max, humidity}
    rescue
      _ -> :error
    end
  end

  defp apikey() do
    "e745eae4765b7fdd7841f9980f413f09"
  end
end
