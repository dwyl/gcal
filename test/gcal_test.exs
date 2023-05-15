defmodule GcalTest do
  use ExUnit.Case
  doctest Gcal

  test "get_calendar_list/1 returns the available calendars" do
    access_token = System.get_env("TOKEN")
    {:ok, cal_list} = Gcal.get_calendar_list(access_token)
    cal = List.first(cal_list.items)
    assert cal.id == "nelson@gmail.com-TEST"
  end

  test "get_calendar_details/2 returns the calendar details" do
    access_token = System.get_env("TOKEN")
    {:ok, cal_detail} = Gcal.get_calendar_details(access_token, "primary")
    assert cal_detail.id == "nelson@gmail.com-TEST"
  end

  test "get_event_list/3 gets the event list for the specified calendar" do
    access_token = System.get_env("TOKEN")
    timezone = "Etc/UTC+01:00"
    datetime = Timex.now(timezone)
    {:ok, event_list} = Gcal.get_event_list(access_token, datetime, "primary")
    # dbg(event_list)
    first_event = List.first(event_list.items)
    assert first_event.summary == "First Event"
    # assert cal_detail.id == "nelson@gmail.com-TEST"
  end

  test "create_event/2 creates an event in the desired calendar" do
    access_token = System.get_env("TOKEN")

    event_detail = %{
      "all_day" => false,
      date: "2023-05-15",
      hoursFromUTC: "+0100",
      start: "16:00",
      stop: "18:00",
      title: "My Awesome Event"
    }

    {:ok, event} = Gcal.create_event(access_token, event_detail, "primary")
    # dbg(event)
    assert event.summary == event_detail.title
  end

  test "create_event/3 all_day=true" do
    access_token = System.get_env("TOKEN")

    event_detail = %{
      all_day: true,
      date: "2023-05-15",
      hoursFromUTC: "+0100",
      start: "16:00",
      stop: "18:00",
      title: "My Awesome Event"
    }

    {:ok, event} = Gcal.create_event(access_token, event_detail, "primary")
    # dbg(event)
    assert event.summary == event_detail.title
  end
end
