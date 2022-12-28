defmodule CESQLTest do
  use ExUnit.Case, async: true
  doctest CESQL

  test "extract field from CloudEvent" do
    event =
      Cloudevents.from_map!(%{
        specversion: "1.0",
        source: "myapp",
        id: "abc123",
        type: "some.event"
      })

    assert CESQL.query(event, "source") == "myapp"
  end

  test "extract extension field from CloudEvent" do
    event =
      Cloudevents.from_map!(%{
        specversion: "1.0",
        source: "myapp",
        id: "abc123",
        type: "some.event",
        sequence: 100
      })

    assert CESQL.query(event, "sequence") == 100
  end
end
