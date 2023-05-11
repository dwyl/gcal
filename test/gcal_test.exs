defmodule GcalTest do
  use ExUnit.Case
  doctest Gcal

  test "get_calendar_details/2 returns the calendar details" do
    token = System.get_env("TOKEN")
    {:ok, cal_detail} = Gcal.get_calendar_details(token, "primary")
    assert cal_detail.id == "nelson@gmail.com-TEST"
  end
end
