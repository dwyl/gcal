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
      httpoison().get("#{@baseurl}/calendars/#{primary_cal.id}/events", headers(access_token),
        params: params
      )
      |> parse_body_response()

    {primary_cal, event_list}
  end

  @doc """
  `create_event/3` creates a new event in the desired calendar

  Arguments:

  `acces_token`: the valid `Google` Auth Session token.
  `event_details`: the details of the event to be created
  `cal_name`(optional): the calendar to create the event in
  """
  # Create new event to the primary calendar.
  def create_event(access_token, %{
         "title" => title,
         "date" => date,
         "start" => start,
         "stop" => stop,
         "all_day" => all_day,
         "hoursFromUTC" => hoursFromUTC
       }, cal_name \\ "primary") do

    # Get primary calendar
    {:ok, primary_cal} = get_calendar_details(access_token, cal_name)

    # Setting `start` and `stop` according to the `all-day` boolean,
    # If `all-day` is set to true, we should return the date instead of the datetime,
    # as per https://developers.google.com/calendar/api/v3/reference/events/insert.
    start =
      case all_day do
        true ->
          %{date: date}

        false ->
          %{
            dateTime:
              Timex.parse!("#{date} #{start} #{hoursFromUTC}", "{YYYY}-{0M}-{D} {h24}:{m} {Z}")
              |> Timex.format!("{RFC3339}")
          }
      end

    stop =
      case all_day do
        true ->
          %{date: date}

        false ->
          %{
            dateTime:
              Timex.parse!("#{date} #{stop} #{hoursFromUTC}", "{YYYY}-{0M}-{D} {h24}:{m} {Z}")
              |> Timex.format!("{RFC3339}")
          }
      end

    # Post new event
    body = Jason.encode!(%{summary: title, start: start, end: stop})

    httpoison().post(
      "#{@baseurl}/calendars/#{primary_cal.id}/events",
      body,
      headers(access_token)
    )
    |> parse_body_response()
  end

  # Parse JSON body response
  defp parse_body_response({:ok, response}) do
    body = Map.get(response, :body)
    # make keys of map atoms for easier access in templates
    if body == nil do
      {:error, :no_body}
    else
      {:ok, str_key_map} = Jason.decode(body)
      # github.com/dwyl/useful#atomize_map_keys1
      {:ok, Useful.atomize_map_keys(str_key_map)}
    end
  end
end
