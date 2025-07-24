defmodule Washer.WorkersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Washer.Workers` context.
  """

  @doc """
  Generate a worker.
  """
  def worker_fixture(attrs \\ %{}) do
    {:ok, worker} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        phone_number: "some phone_number"
      })
      |> Washer.Workers.create_worker()

    worker
  end
end
