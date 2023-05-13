defmodule Gcal do
  import Gcal.HTTPoison

  @moduledoc """
  `Gcal` helps you interact with your `Google` Calendar via the API.
  """

  @baseurl "https://www.googleapis.com/calendar/v3"

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
  `get_calendar_list/1` gets the list of available calendars for the person.
  https://developers.google.com/calendar/api/v3/reference/calendarList/list

  Arguments:

  `access_token`: the valid `Google` Auth access token.

  Sample response:

  {:ok, %{
    etag: "\"p320ebocgmjpfs0g\"",
    items: [
      %{
        "accessRole" => "owner",
        "backgroundColor" => "#9fe1e7",
        "colorId" => "14",
        "conferenceProperties" => %{
          "allowedConferenceSolutionTypes" => ["hangoutsMeet"]
        },
        "defaultReminders" => [%{"method" => "popup", "minutes" => 10}],
        "etag" => "\"1553070512390000\"",
        "foregroundColor" => "#000000",
        "id" => "nelson@gmail.com",
        "kind" => "calendar#calendarListEntry",
        "notificationSettings" => %{
          "notifications" => [
            %{"method" => "email", "type" => "eventCreation"},
            %{"method" => "email", "type" => "eventChange"},
            %{"method" => "email", "type" => "eventCancellation"},
            %{"method" => "email", "type" => "eventResponse"}
          ]
        },
        "primary" => true,
        "selected" => true,
        "summary" => "nelson@gmail.com",
        "timeZone" => "Europe/London"
      },
      %{
        "accessRole" => "owner",
        "backgroundColor" => "#d06b64",
        "colorId" => "2",
        "conferenceProperties" => %{
          "allowedConferenceSolutionTypes" => ["hangoutsMeet"]
        },
        "defaultReminders" => [],
        "etag" => "\"1553070512692000\"",
        "foregroundColor" => "#000000",
        "id" => "rpia5b9frqmvvd549c1scs82mk@group.calendar.google.com",
        "kind" => "calendar#calendarListEntry",
        "location" => "London, UK",
        "selected" => true,
        "summary" => "dwyl",
        "timeZone" => "Europe/London"
      }
    ],
    kind: "calendar#calendarList",
    nextSyncToken: "CIDl4ZC08v4CEg9uZWxzb25AZHd5bC5jb20="
  }}
  """
  def get_calendar_list(access_token) do
    httpoison().get("#{@baseurl}/users/me/calendarList", headers(access_token))
    |> parse_body_response()
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
    httpoison().get("#{@baseurl}/calendars/#{cal_name}", headers(access_token))
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
      httpoison().get("#{@baseurl}/calendars/#{primary_cal.id}/events", headers(access_token), params: params)
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
      {:ok, Useful.atomize_map_keys(str_key_map)}
    end
  end
end
