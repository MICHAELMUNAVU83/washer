defmodule WasherWeb.WorkerLiveTest do
  use WasherWeb.ConnCase

  import Phoenix.LiveViewTest
  import Washer.WorkersFixtures

  @create_attrs %{name: "some name", email: "some email", phone_number: "some phone_number"}
  @update_attrs %{name: "some updated name", email: "some updated email", phone_number: "some updated phone_number"}
  @invalid_attrs %{name: nil, email: nil, phone_number: nil}

  defp create_worker(_) do
    worker = worker_fixture()
    %{worker: worker}
  end

  describe "Index" do
    setup [:create_worker]

    test "lists all workers", %{conn: conn, worker: worker} do
      {:ok, _index_live, html} = live(conn, ~p"/workers")

      assert html =~ "Listing Workers"
      assert html =~ worker.name
    end

    test "saves new worker", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/workers")

      assert index_live |> element("a", "New Worker") |> render_click() =~
               "New Worker"

      assert_patch(index_live, ~p"/workers/new")

      assert index_live
             |> form("#worker-form", worker: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#worker-form", worker: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/workers")

      html = render(index_live)
      assert html =~ "Worker created successfully"
      assert html =~ "some name"
    end

    test "updates worker in listing", %{conn: conn, worker: worker} do
      {:ok, index_live, _html} = live(conn, ~p"/workers")

      assert index_live |> element("#workers-#{worker.id} a", "Edit") |> render_click() =~
               "Edit Worker"

      assert_patch(index_live, ~p"/workers/#{worker}/edit")

      assert index_live
             |> form("#worker-form", worker: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#worker-form", worker: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/workers")

      html = render(index_live)
      assert html =~ "Worker updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes worker in listing", %{conn: conn, worker: worker} do
      {:ok, index_live, _html} = live(conn, ~p"/workers")

      assert index_live |> element("#workers-#{worker.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#workers-#{worker.id}")
    end
  end

  describe "Show" do
    setup [:create_worker]

    test "displays worker", %{conn: conn, worker: worker} do
      {:ok, _show_live, html} = live(conn, ~p"/workers/#{worker}")

      assert html =~ "Show Worker"
      assert html =~ worker.name
    end

    test "updates worker within modal", %{conn: conn, worker: worker} do
      {:ok, show_live, _html} = live(conn, ~p"/workers/#{worker}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Worker"

      assert_patch(show_live, ~p"/workers/#{worker}/show/edit")

      assert show_live
             |> form("#worker-form", worker: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#worker-form", worker: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/workers/#{worker}")

      html = render(show_live)
      assert html =~ "Worker updated successfully"
      assert html =~ "some updated name"
    end
  end
end
