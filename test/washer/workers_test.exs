defmodule Washer.WorkersTest do
  use Washer.DataCase

  alias Washer.Workers

  describe "workers" do
    alias Washer.Workers.Worker

    import Washer.WorkersFixtures

    @invalid_attrs %{name: nil, email: nil, phone_number: nil}

    test "list_workers/0 returns all workers" do
      worker = worker_fixture()
      assert Workers.list_workers() == [worker]
    end

    test "get_worker!/1 returns the worker with given id" do
      worker = worker_fixture()
      assert Workers.get_worker!(worker.id) == worker
    end

    test "create_worker/1 with valid data creates a worker" do
      valid_attrs = %{name: "some name", email: "some email", phone_number: "some phone_number"}

      assert {:ok, %Worker{} = worker} = Workers.create_worker(valid_attrs)
      assert worker.name == "some name"
      assert worker.email == "some email"
      assert worker.phone_number == "some phone_number"
    end

    test "create_worker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workers.create_worker(@invalid_attrs)
    end

    test "update_worker/2 with valid data updates the worker" do
      worker = worker_fixture()
      update_attrs = %{name: "some updated name", email: "some updated email", phone_number: "some updated phone_number"}

      assert {:ok, %Worker{} = worker} = Workers.update_worker(worker, update_attrs)
      assert worker.name == "some updated name"
      assert worker.email == "some updated email"
      assert worker.phone_number == "some updated phone_number"
    end

    test "update_worker/2 with invalid data returns error changeset" do
      worker = worker_fixture()
      assert {:error, %Ecto.Changeset{}} = Workers.update_worker(worker, @invalid_attrs)
      assert worker == Workers.get_worker!(worker.id)
    end

    test "delete_worker/1 deletes the worker" do
      worker = worker_fixture()
      assert {:ok, %Worker{}} = Workers.delete_worker(worker)
      assert_raise Ecto.NoResultsError, fn -> Workers.get_worker!(worker.id) end
    end

    test "change_worker/1 returns a worker changeset" do
      worker = worker_fixture()
      assert %Ecto.Changeset{} = Workers.change_worker(worker)
    end
  end
end
