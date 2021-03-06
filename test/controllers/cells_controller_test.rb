require 'test_helper'

class CellsControllerTest < ActionController::TestCase
  setup do
    @cell = cells(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cells)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cell" do
    assert_difference('Cell.count') do
      post :create, cell: { cell_type: @cell.cell_type, coordinate_x: @cell.coordinate_x, coordinate_y: @cell.coordinate_y, table_id: @cell.table_id }
    end

    assert_redirected_to cell_path(assigns(:cell))
  end

  test "should show cell" do
    get :show, id: @cell
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cell
    assert_response :success
  end

  test "should update cell" do
    patch :update, id: @cell, cell: { cell_type: @cell.cell_type, coordinate_x: @cell.coordinate_x, coordinate_y: @cell.coordinate_y, table_id: @cell.table_id }
    assert_redirected_to cell_path(assigns(:cell))
  end

  test "should destroy cell" do
    assert_difference('Cell.count', -1) do
      delete :destroy, id: @cell
    end

    assert_redirected_to cells_path
  end
end
