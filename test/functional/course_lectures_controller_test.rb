require File.dirname(__FILE__) + '/../test_helper'

class CourseLecturesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:course_lectures)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_course_lecture
    assert_difference('CourseLecture.count') do
      post :create, :course_lecture => { }
    end

    assert_redirected_to course_lecture_path(assigns(:course_lecture))
  end

  def test_should_show_course_lecture
    get :show, :id => course_lectures(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => course_lectures(:one).id
    assert_response :success
  end

  def test_should_update_course_lecture
    put :update, :id => course_lectures(:one).id, :course_lecture => { }
    assert_redirected_to course_lecture_path(assigns(:course_lecture))
  end

  def test_should_destroy_course_lecture
    assert_difference('CourseLecture.count', -1) do
      delete :destroy, :id => course_lectures(:one).id
    end

    assert_redirected_to course_lectures_path
  end
end
