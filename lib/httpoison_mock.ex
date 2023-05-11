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
  Returns a calendar object with random data.
  See https://developers.google.com/calendar/api/v3/reference/calendars
  Obviously, don't invoke it from your App unless you want people to see fails.
  """
  def get("https://www.googleapis.com/calendar/v3/calendars/primary", _headers) do
    body = Jason.encode!(%{
      conferenceProperties: %{"allowedConferenceSolutionTypes" => ["hangoutsMeet"]},
      etag: "\"oftesUJ77GfcrwCPCmctnI90Qzs\"",
      id: "nelson@gmail.com-TEST",
      kind: "calendar#calendar",
      summary: "nelson@gmail.com",
      timeZone: "Europe/London"
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
  post/2 will just return a mocked success.
  """
  def post(_url, _body, _headers) do
    {:ok, %{body: Jason.encode!(%{})}}
  end
end
