require File.dirname(__FILE__) + '/../test_helper'
require 'preferences_controller'

# Re-raise errors caught by the controller.
class PreferencesController; def rescue_action(e) raise e end; end

class PreferencesControllerTest < Test::Unit::TestCase
  fixtures :preferences

  def setup
    @controller = PreferencesController.new
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

    assert_not_nil assigns(:preferences)
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:preference)
  end

  def test_create
    num_preferences = Preference.count

    post :create, :preference => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_preferences + 1, Preference.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:preference)
    assert assigns(:preference).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Preference.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Preference.find(1)
    }
  end
end
