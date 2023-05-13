defmodule GcalTest do
  use ExUnit.Case
  doctest Gcal

  test "get_calendar_list/1 returns the available calendars" do
    token = System.get_env("TOKEN")
    {:ok, cals} = Gcal.get_calendar_list(token)
    cal = List.first(cals.items)
    assert cal.id == "nelson@gmail.com-TEST"
  end

  test "get_calendar_details/2 returns the calendar details" do
    token = System.get_env("TOKEN")
    {:ok, cal_detail} = Gcal.get_calendar_details(token, "primary")
    assert cal_detail.id == "nelson@gmail.com-TEST"
  end
end
