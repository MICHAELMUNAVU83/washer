defmodule Washer.BranchesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Washer.Branches` context.
  """

  @doc """
  Generate a branch.
  """
  def branch_fixture(attrs \\ %{}) do
    {:ok, branch} =
      attrs
      |> Enum.into(%{
        location: "some location",
        name: "some name"
      })
      |> Washer.Branches.create_branch()

    branch
  end
end
