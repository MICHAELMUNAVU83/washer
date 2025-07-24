defmodule WasherWeb.CarLiveTest do
  use WasherWeb.ConnCase

  import Phoenix.LiveViewTest
  import Washer.CarsFixtures

  @create_attrs %{name: "some name", number_plate: "some number_plate", email: "some email", phone_number: "some phone_number"}
  @update_attrs %{name: "some updated name", number_plate: "some updated number_plate", email: "some updated email", phone_number: "some updated phone_number"}
  @invalid_attrs %{name: nil, number_plate: nil, email: nil, phone_number: nil}

  defp create_car(_) do
    car = car_fixture()
    %{car: car}
  end

  describe "Index" do
    setup [:create_car]

    test "lists all cars", %{conn: conn, car: car} do
      {:ok, _index_live, html} = live(conn, ~p"/cars")

      assert html =~ "Listing Cars"
      assert html =~ car.name
    end

    test "saves new car", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/cars")

      assert index_live |> element("a", "New Car") |> render_click() =~
               "New Car"

      assert_patch(index_live, ~p"/cars/new")

      assert index_live
             |> form("#car-form", car: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#car-form", car: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cars")

      html = render(index_live)
      assert html =~ "Car created successfully"
      assert html =~ "some name"
    end

    test "updates car in listing", %{conn: conn, car: car} do
      {:ok, index_live, _html} = live(conn, ~p"/cars")

      assert index_live |> element("#cars-#{car.id} a", "Edit") |> render_click() =~
               "Edit Car"

      assert_patch(index_live, ~p"/cars/#{car}/edit")

      assert index_live
             |> form("#car-form", car: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#car-form", car: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cars")

      html = render(index_live)
      assert html =~ "Car updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes car in listing", %{conn: conn, car: car} do
      {:ok, index_live, _html} = live(conn, ~p"/cars")

      assert index_live |> element("#cars-#{car.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cars-#{car.id}")
    end
  end

  describe "Show" do
    setup [:create_car]

    test "displays car", %{conn: conn, car: car} do
      {:ok, _show_live, html} = live(conn, ~p"/cars/#{car}")

      assert html =~ "Show Car"
      assert html =~ car.name
    end

    test "updates car within modal", %{conn: conn, car: car} do
      {:ok, show_live, _html} = live(conn, ~p"/cars/#{car}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Car"

      assert_patch(show_live, ~p"/cars/#{car}/show/edit")

      assert show_live
             |> form("#car-form", car: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#car-form", car: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/cars/#{car}")

      html = render(show_live)
      assert html =~ "Car updated successfully"
      assert html =~ "some updated name"
    end
  end
end
