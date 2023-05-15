defmodule GcalHTTPoisonMockTest do
  use ExUnit.Case

  # This test only exists because we are using a "cond" in post/3
  # for future-proofing the function.
  test "Gcal.HTTPoisonMock.post returns empty map" do
    {:ok, data} = Gcal.HTTPoisonMock.post("any", "body", "headers")
    dbg(data)
    assert data == %{body: "{}"}
  end
end
