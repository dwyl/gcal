defmodule Gcal.HTTPoison do
  @moduledoc """
  `Gcal.HTTPoison` uses `HTTPoison` on production envs
  and `Mocks` behaviour when testing.
  """

  @httpoison (Application.compile_env(:gcal, :httpoison_mock) && Gcal.HTTPoisonMock) ||
               HTTPoison
  # @baseurl "https://www.googleapis.com/calendar/v3/calendars/"

  @doc """
  `inject_poison/0` injects a TestDouble of HTTPoison in Test
  so that we don't have duplicate mock in consuming apps.
  see: https://github.com/dwyl/elixir-auth-google/issues/35
  """
  def httpoison, do: @httpoison
end

defmodule Gcal.HTTPoisonMock do
  @moduledoc """
  This is a TestDouble for HTTPoison which returns a predictable response.
  Please see: github.com/dwyl/elixir-auth-google/issues/35
  """

  @doc """
  `get/1` retrieves the calendar.
  Returns a calendar object with valid data.
  https://developers.google.com/calendar/api/v3/reference/calendars
  """
  def get("https://www.googleapis.com/calendar/v3/calendars/primary", _headers) do
    body =
      Jason.encode!(%{
        conferenceProperties: %{"allowedConferenceSolutionTypes" => ["hangoutsMeet"]},
        etag: "\"oftesUJ77GfcrwCPCmctnI90Qzs\"",
        id: "nelson@gmail.com-TEST",
        kind: "calendar#calendar",
        summary: "nelson@gmail.com",
        timeZone: "Europe/London"
      })

    {:ok, %{body: body}}
  end

  # https://developers.google.com/calendar/api/v3/reference/calendarList/list

  def get("https://www.googleapis.com/calendar/v3/users/me/calendarList", _headers) do
    body =
      Jason.encode!(%{
        etag: "\"p320ebocgmjpfs0g\"",
        items: [
          %{
            accessRole: "owner",
            backgroundColor: "#9fe1e7",
            colorId: "14",
            conferenceProperties: %{allowedConferenceSolutionTypes: ["hangoutsMeet"]},
            defaultReminders: [%{method: "popup", minutes: 10}],
            etag: "\"1553070512390000\"",
            foregroundColor: "#000000",
            id: "nelson@gmail.com-TEST",
            kind: "calendar#calendarListEntry",
            notificationSettings: %{
              notifications: [
                %{method: "email", type: "eventCreation"},
                %{method: "email", type: "eventChange"},
                %{method: "email", type: "eventCancellation"},
                %{method: "email", type: "eventResponse"}
              ]
            },
            primary: true,
            selected: true,
            summary: "nelson@mail.com",
            timeZone: "Europe/London"
          },
          %{
            accessRole: "owner",
            backgroundColor: "#d06b64",
            colorId: "2",
            conferenceProperties: %{allowedConferenceSolutionTypes: ["hangoutsMeet"]},
            defaultReminders: [],
            etag: "\"1553070512692000\"",
            foregroundColor: "#000000",
            id: "dwyl.io_rpia5b9frqmvvd549c1scs82mk@group.calendar.google.com",
            kind: "calendar#calendarListEntry",
            location: "London, UK",
            selected: true,
            summary: "dwyl",
            timeZone: "Europe/London"
          },
          %{
            accessRole: "reader",
            backgroundColor: "#16a765",
            colorId: "8",
            conferenceProperties: %{allowedConferenceSolutionTypes: ["hangoutsMeet"]},
            defaultReminders: [],
            description: "Holidays and Observances in United Kingdom",
            etag: "\"1558367364937000\"",
            foregroundColor: "#000000",
            id: "en.uk#holiday@group.v.calendar.google.com",
            kind: "calendar#calendarListEntry",
            selected: true,
            summary: "Holidays in United Kingdom",
            summaryOverride: "Holidays in United Kingdom",
            timeZone: "Europe/London"
          }
        ],
        kind: "calendar#calendarList",
        nextSyncToken: "CIDl4ZC08v4CEg9uZWxzb25AZHd5bC5jb20="
      })

    {:ok, %{body: body}}
  end

  @doc """
  `get/1` catch-all get function returns mock event list.
  """
  def get(_url, _headers, params: _params) do
    body =
      Jason.encode!(%{
        items: [
          %{
            "created" => "2022-03-22T12:34:08.000Z",
            "creator" => %{"email" => "hello@gmail.com", "self" => true},
            "end" => %{"date" => "2023-04-22"},
            "id" => "cphjep9g6dgj2b9g6kpj2b9k6hijgb9oc8pj0bb66kqj4db16op38db36s_20230421",
            "organizer" => %{"email" => "hello@gmail.com", "self" => true},
            "originalStartTime" => %{"date" => "2023-04-21"},
            "start" => %{"date" => "2023-04-21"},
            "status" => "confirmed",
            "summary" => "First Event"
          },
          %{
            "created" => "2022-03-23T12:34:08.000Z",
            "creator" => %{"email" => "hello@gmail.com", "self" => true},
            "end" => %{
              "dateTime" => "2023-03-20T02:00:00Z",
              "timeZone" => "Europe/Lisbon"
            },
            "id" => "cphjep9g6dgjasdasdghsa1234gsa4db16op38db36asd1sdfas1",
            "organizer" => %{"email" => "hello@gmail.com", "self" => true},
            "originalStartTime" => %{"date" => "2023-04-21"},
            "start" => %{
              "dateTime" => "2023-03-20T01:00:00Z",
              "timeZone" => "Europe/Lisbon"
            },
            "status" => "confirmed",
            "summary" => "Second Event"
          }
        ]
      })

    {:ok, %{body: body}}
  end

  @doc """
  post/2 for create_event/3 returns valid event data
  """
  def post(url, _body, _headers) do
    data =
      cond do
        String.contains?(url, "/events") ->
          %{
            created: "2023-05-15T09:31:18.000Z",
            creator: %{email: "nelson@gmail.com", self: true},
            end: %{dateTime: "2023-05-15T18:00:00+01:00", timeZone: "Europe/London"},
            etag: "\"3368286156450000\"",
            eventType: "default",
            htmlLink:
              "https://www.google.com/calendar/event?eid=ODI5YXRxM2k1bmdobGg3ZjM3c2FzODZuaTAgbmVsc29uQGR3eWwuY29t",
            iCalUID: "829atq3i5nghlh7f37sas86ni0@google.com",
            id: "829atq3i5nghlh7f37sas86ni0",
            kind: "calendar#event",
            organizer: %{email: "nelson@gmail.com", self: true},
            reminders: %{useDefault: true},
            sequence: 0,
            start: %{dateTime: "2023-05-15T16:00:00+01:00", timeZone: "Europe/London"},
            status: "confirmed",
            summary: "My Awesome Event",
            updated: "2023-05-15T09:31:18.225Z"
          }

        true ->
          %{}
      end

    {:ok, %{body: Jason.encode!(data)}}
  end
end
