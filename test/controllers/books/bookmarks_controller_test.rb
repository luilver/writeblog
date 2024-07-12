require "test_helper"

class Blogs::BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kevin
  end

  test "show includes a link to read the last read leaf" do
    cookies["reading_progress_#{blogs(:handbook).id}"] = "#{leaves(:welcome_page).id}/3"

    get blog_bookmark_url(blogs(:handbook))

    assert_response :success
    assert_select "a", /Resume reading/
  end

  test "show includes a link to start reading if the last read leaf has been trashed" do
    leaves(:welcome_page).trashed!
    cookies["reading_progress_#{blogs(:handbook).id}"] = "#{leaves(:welcome_page).id}/3"

    get blog_bookmark_url(blogs(:handbook))

    assert_response :success
    assert_select "a", /Start reading/
  end

  test "show includes a link to start reading if no reading progress has been recorded" do
    get blog_bookmark_url(blogs(:handbook))

    assert_response :success
    assert_select "a", /Start reading/
  end
end
