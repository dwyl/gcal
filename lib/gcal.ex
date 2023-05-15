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

  ```elixir
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
  ```
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

  Sample response:

  ```elixir
  %{
  accessRole: "owner",
  defaultReminders: [%{method: "popup", minutes: 10}],
  etag: "\"p32odpveognrvs0g\"",
  items: [
    %{
      attendees: [
        %{email: "nelson@gmail.com", responseStatus: "accepted", self: true},
        %{email: "ines@gmail.com", organizer: true, responseStatus: "accepted"},
        %{email: "simon@gmail.com", responseStatus: "accepted"},
        %{email: "busy@gmail.com", responseStatus: "declined"}
      ],
      created: "2019-11-10T17:39:38.000Z",
      creator: %{email: "ines@gmail.com"},
      description: "Daily Standup for @dwyl team",
      end: %{dateTime: "2023-05-15T10:00:00+01:00", timeZone: "Europe/London"},
      etag: "\"3359131283178000\"",
      eventType: "default",
      htmlLink: "https://www.google.com/calendar/event?eid=a21pMWVicWpqYzYy",
      iCalUID: "kmi1ebqjjc62s2hlukjj706unq_R20230324T093000@google.com",
      id: "kmi1ebqjjc62s2hlukjj706unq_20230515T083000Z",
      kind: "calendar#event",
      location: "https://zoom.us/j/33713371",
      organizer: %{email: "ines@gmail.com"},
      originalStartTime: %{
        dateTime: "2023-05-15T09:30:00+01:00",
        timeZone: "Europe/London"
      },
      recurringEventId: "kmi1ebqjjc62s2hlukjj706unq_R20230324T093000",
      reminders: %{useDefault: true},
      sequence: 2,
      start: %{dateTime: "2023-05-15T09:30:00+01:00", timeZone: "Europe/London"},
      status: "confirmed",
      summary: "Daily Standup",
      updated: "2023-03-23T10:00:41.589Z"
    },
    %{
      attendees: [
        %{email: "nelson@gmail.com", responseStatus: "accepted", self: true},
        %{
          email: "ines@gmail.com",
          organizer: true,
          responseStatus: "accepted"
        }
      ],
      created: "2023-04-28T08:21:26.000Z",
      creator: %{email: "ines@gmail.com"},
      end: %{dateTime: "2023-05-15T17:00:00+01:00", timeZone: "Europe/London"},
      etag: "\"3367047572704000\"",
      eventType: "default",
      htmlLink: "https://www.google.com/calendar/event?eid=cnNodDJvMnRmcDNyMjN",
      iCalUID: "rsht2o2tfp3r23kfqfc4pip@google.com",
      id: "rsht2o2tfp3r23kfqfc4pip",
      kind: "calendar#event",
      organizer: %{email: "ines@gmail.com"},
      reminders: %{useDefault: true},
      sequence: 1,
      start: %{dateTime: "2023-05-15T09:00:00+01:00", timeZone: "Europe/London"},
      status: "confirmed",
      summary: "House Work",
      updated: "2023-05-08T05:29:46.352Z"
    },
    %{
      created: "2023-05-15T09:48:24.000Z",
      creator: %{email: "nelson@dwyl.com", self: true},
      end: %{dateTime: "2023-05-15T15:00:00+01:00", timeZone: "Europe/London"},
      etag: "\"3368288209788000\"",
      eventType: "default",
      htmlLink: "https://www.google.com/calendar/event?eid=OHQ1dHNyaHM0cDdpZG",
      iCalUID: "8t5tsrhs4p7idmuj5ap8457ppc@google.com",
      id: "8t5tsrhs4p7idmuj5ap8457ppc",
      kind: "calendar#event",
      organizer: %{email: "nelson@dwyl.com", self: true},
      reminders: %{useDefault: true},
      sequence: 0,
      start: %{dateTime: "2023-05-15T14:00:00+01:00", timeZone: "Europe/London"},
      status: "confirmed",
      summary: "New Event using Gcal",
      updated: "2023-05-15T09:48:24.894Z"
    }
  ],
  kind: "calendar#events",
  nextSyncToken: "CLDc_diF9_4CELDc_diF9_4CGAUgluyY_AE=",
  summary: "nelson@gmail.com",
  timeZone: "Europe/London",
  updated: "2023-05-15T09:48:24.894Z"
  }
  ```
  """
  def get_event_list(access_token, datetime, cal_name \\ "primary") do
    # Get primary calendar
    {:ok, cal} = get_calendar_details(access_token, cal_name)

    # Get events of primary calendar
    params = %{
      singleEvents: true,
      timeMin: datetime |> Timex.beginning_of_day() |> Timex.format!("{RFC3339}"),
      timeMax: datetime |> Timex.end_of_day() |> Timex.format!("{RFC3339}")
    }

    {:ok, event_list} =
      httpoison().get("#{@baseurl}/calendars/#{cal.id}/events", headers(access_token),
        params: params
      )
      |> parse_body_response()

    {:ok, event_list}
  end

  @doc """
  `create_event/3` creates a new event in the desired calendar

  Arguments:

  `acces_token`: the valid `Google` Auth Session token.
  `event_details`: the details of the event to be created
  `cal_name`(optional): the calendar to create the event in
  """
  # Create new event to the primary calendar.
  def create_event(
        access_token,
        %{
          "title" => title,
          "date" => date,
          "start" => start,
          "stop" => stop,
          "all_day" => all_day,
          "hoursFromUTC" => hoursFromUTC
        },
        cal_name \\ "primary"
      ) do
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

  # TODO: split the `all_day/2` function out from `create_event/3` ...

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
