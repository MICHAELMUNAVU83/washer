defmodule WasherWeb.BranchLiveTest do
  use WasherWeb.ConnCase

  import Phoenix.LiveViewTest
  import Washer.BranchesFixtures

  @create_attrs %{name: "some name", location: "some location"}
  @update_attrs %{name: "some updated name", location: "some updated location"}
  @invalid_attrs %{name: nil, location: nil}

  defp create_branch(_) do
    branch = branch_fixture()
    %{branch: branch}
  end

  describe "Index" do
    setup [:create_branch]

    test "lists all branches", %{conn: conn, branch: branch} do
      {:ok, _index_live, html} = live(conn, ~p"/branches")

      assert html =~ "Listing Branches"
      assert html =~ branch.name
    end

    test "saves new branch", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/branches")

      assert index_live |> element("a", "New Branch") |> render_click() =~
               "New Branch"

      assert_patch(index_live, ~p"/branches/new")

      assert index_live
             |> form("#branch-form", branch: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#branch-form", branch: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/branches")

      html = render(index_live)
      assert html =~ "Branch created successfully"
      assert html =~ "some name"
    end

    test "updates branch in listing", %{conn: conn, branch: branch} do
      {:ok, index_live, _html} = live(conn, ~p"/branches")

      assert index_live |> element("#branches-#{branch.id} a", "Edit") |> render_click() =~
               "Edit Branch"

      assert_patch(index_live, ~p"/branches/#{branch}/edit")

      assert index_live
             |> form("#branch-form", branch: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#branch-form", branch: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/branches")

      html = render(index_live)
      assert html =~ "Branch updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes branch in listing", %{conn: conn, branch: branch} do
      {:ok, index_live, _html} = live(conn, ~p"/branches")

      assert index_live |> element("#branches-#{branch.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#branches-#{branch.id}")
    end
  end

  describe "Show" do
    setup [:create_branch]

    test "displays branch", %{conn: conn, branch: branch} do
      {:ok, _show_live, html} = live(conn, ~p"/branches/#{branch}")

      assert html =~ "Show Branch"
      assert html =~ branch.name
    end

    test "updates branch within modal", %{conn: conn, branch: branch} do
      {:ok, show_live, _html} = live(conn, ~p"/branches/#{branch}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Branch"

      assert_patch(show_live, ~p"/branches/#{branch}/show/edit")

      assert show_live
             |> form("#branch-form", branch: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#branch-form", branch: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/branches/#{branch}")

      html = render(show_live)
      assert html =~ "Branch updated successfully"
      assert html =~ "some updated name"
    end
  end
end
