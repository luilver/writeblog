require "test_helper"

class LeafablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kevin
  end

  test "show" do
    get leafable_slug_path(leaves(:welcome_page))

    assert_response :success
    assert_select "p", "This is such a great handbook."
  end

  test "show with public access to a published blog" do
    sign_out
    blogs(:handbook).update!(published: true)

    get leafable_slug_path(leaves(:welcome_page))

    assert_response :success
    assert_select "p", "This is such a great handbook."
  end

  test "show does not allow public access to an unpublished blog" do
    sign_out

    get leafable_slug_path(leaves(:welcome_page))

    assert_response :not_found
  end

  test "create" do
    assert_changes -> { blogs(:handbook).leaves.count }, +1 do
      post blog_pages_path(blogs(:handbook), format: :turbo_stream), params: {
        leaf: { title: "Another page" }, page: { body: "With interesting words." }
      }
    end

    assert_response :success
  end

  test "create requires editor access" do
    blogs(:handbook).access_for(user: users(:kevin)).update! level: :reader

    assert_no_changes -> { blogs(:handbook).leaves.count } do
      post blog_pages_path(blogs(:handbook), format: :turbo_stream), params: {
        leaf: { title: "Another page" }, page: { body: "With interesting words." }
      }
    end

    assert_response :forbidden
  end
end
