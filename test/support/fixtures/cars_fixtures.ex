defmodule Washer.CarsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Washer.Cars` context.
  """

  @doc """
  Generate a car.
  """
  def car_fixture(attrs \\ %{}) do
    {:ok, car} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        number_plate: "some number_plate",
        phone_number: "some phone_number"
      })
      |> Washer.Cars.create_car()

    car
  end
end
