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

  test "create_event/2 creates an event in the desired calendar" do
    access_token = System.get_env("TOKEN")
    event_detail = %{
      "all_day" => false,
      "date" => "2023-05-15",
      "hoursFromUTC" => "+0100",
      "start" => "16:00",
      "stop" => "18:00",
      "title" => "My Awesome Event"
    }
    {:ok, event} = Gcal.create_event(access_token, event_detail, "primary")
    # dbg(event)
    assert event.summary == Map.get(event_detail, "title")
  end
end
