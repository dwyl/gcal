defmodule Gcal do
  import Gcal.HTTPoison

  @moduledoc """
  `Gcal` helps you interact with your `Google` Calendar via the API.
  """

  @baseurl "https://www.googleapis.com/calendar/v3/calendars/"

  @doc """
  `headers/1` returns the required headers for making an HTTP request.

  Arguments:
  `acces_token`: the valid `Google` Auth Session token.
  """
  def headers(access_token) do
    [
      Authorization: "Bearer #{access_token}",
      "Content-Type": "application/json"
    ]
  end

  @doc """
  `get_calendar_details/2` gets the details of the desired calendar.

  Arguments:
  `access_token`: the valid `Google` Auth access token
  `datetime`: the date and time of the day to fetch the events.
  `calendar`: (optional) the string name of the calendar; defaults to "primary"

  Sample response:

  {:ok, %{
    conferenceProperties: %{"allowedConferenceSolutionTypes" => ["hangoutsMeet"]},
    etag: "\"oftesUJ77GfcrwCPCmctnI90Qzs\"",
    id: "nelson@gmail.com",
    kind: "calendar#calendar",
    summary: "nelson@gmail.com",
    timeZone: "Europe/London"
  }}

  """
  def get_calendar_details(access_token, cal_name \\ "primary") do
    httpoison().get("#{@baseurl}#{cal_name}", headers(access_token))
    |> parse_body_response()
  end

  @doc """
  `get_event_list/3` gets the list of events of the desired calendar.

  Arguments:
  `access_token`: the valid `Google` Auth Session token
  `datetime`: the date and time of the day to fetch the events.
  `calendar`: (optional) the string name of the calendar; defaults to "primary"
  """
  def get_event_list(access_token, datetime, cal_name \\ "primary") do
    # Get primary calendar
    {:ok, primary_cal} = get_calendar_details(access_token, cal_name)

    # Get events of primary calendar
    params = %{
      singleEvents: true,
      timeMin: datetime |> Timex.beginning_of_day() |> Timex.format!("{RFC3339}"),
      timeMax: datetime |> Timex.end_of_day() |> Timex.format!("{RFC3339}")
    }

    {:ok, event_list} =
      httpoison().get("#{@baseurl}#{primary_cal.id}/events", headers(access_token), params: params)
      |> parse_body_response()

    {primary_cal, event_list}
  end

  # Parse JSON body response
  defp parse_body_response({:ok, response}) do
    body = Map.get(response, :body)
    # make keys of map atoms for easier access in templates
    if body == nil do
      {:error, :no_body}
    else
      {:ok, str_key_map} = Jason.decode(body)
      # https://stackoverflow.com/questions/31990134
      atom_key_map = for {key, val} <- str_key_map, into: %{}, do: {String.to_atom(key), val}
      {:ok, atom_key_map}
    end
  end
end
