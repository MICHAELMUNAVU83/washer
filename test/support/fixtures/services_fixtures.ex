defmodule Washer.ServicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Washer.Services` context.
  """

  @doc """
  Generate a service.
  """
  def service_fixture(attrs \\ %{}) do
    {:ok, service} =
      attrs
      |> Enum.into(%{
        date: ~D[2025-07-23],
        description: "some description",
        time: ~T[14:00:00],
        total_amount: "some total_amount",
        types: "some types"
      })
      |> Washer.Services.create_service()

    service
  end
end
