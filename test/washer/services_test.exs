defmodule Washer.ServicesTest do
  use Washer.DataCase

  alias Washer.Services

  describe "services" do
    alias Washer.Services.Service

    import Washer.ServicesFixtures

    @invalid_attrs %{date: nil, time: nil, description: nil, types: nil, total_amount: nil}

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Services.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Services.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      valid_attrs = %{date: ~D[2025-07-23], time: ~T[14:00:00], description: "some description", types: "some types", total_amount: "some total_amount"}

      assert {:ok, %Service{} = service} = Services.create_service(valid_attrs)
      assert service.date == ~D[2025-07-23]
      assert service.time == ~T[14:00:00]
      assert service.description == "some description"
      assert service.types == "some types"
      assert service.total_amount == "some total_amount"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Services.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      update_attrs = %{date: ~D[2025-07-24], time: ~T[15:01:01], description: "some updated description", types: "some updated types", total_amount: "some updated total_amount"}

      assert {:ok, %Service{} = service} = Services.update_service(service, update_attrs)
      assert service.date == ~D[2025-07-24]
      assert service.time == ~T[15:01:01]
      assert service.description == "some updated description"
      assert service.types == "some updated types"
      assert service.total_amount == "some updated total_amount"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Services.update_service(service, @invalid_attrs)
      assert service == Services.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Services.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Services.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Services.change_service(service)
    end
  end
end
