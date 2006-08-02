require File.dirname(__FILE__) + '/../test_helper'
require 'options_controller'

# Re-raise errors caught by the controller.
class OptionsController; def rescue_action(e) raise e end; end

class OptionsControllerTest < Test::Unit::TestCase
  fixtures :options

  def setup
    @controller = OptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:options)
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:option)
  end

  def test_create
    num_options = Option.count

    post :create, :option => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_options + 1, Option.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:option)
    assert assigns(:option).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Option.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Option.find(1)
    }
  end
end
