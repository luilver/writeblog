require "test_helper"

class BlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kevin
  end

  test "index lists the current user's blogs" do
    get root_url

    assert_response :success
    assert_select "h2", text: "Handbook"
    assert_select "h2", text: "Manual", count: 0
  end

  test "index includes published blogs, even when the user does not have access" do
    blogs(:manual).update!(published: true)

    get root_url

    assert_response :success
    assert_select "h2", text: "Handbook"
    assert_select "h2", text: "Manual"
  end

  test "index shows published blogs when not logged in" do
    blogs(:manual).update!(published: true)

    sign_out
    get root_url

    assert_response :success
    assert_select "h2", text: "Handbook", count: 0
    assert_select "h2", text: "Manual"
  end

  test "index redirects to login if not signed in and no published blogs exist" do
    sign_out
    get root_url

    assert_redirected_to new_session_url
  end

  test "create makes the current user an editor" do
    assert_difference -> { Blog.count }, +1 do
      post blogs_url, params: { blog: { title: "New Blog", everyone_access: false } }
    end

    assert_redirected_to blog_slug_url(Blog.last)

    blog = Blog.last
    assert_equal "New Blog", blog.title
    assert_equal 1, Blog.last.accesses.count

    assert blog.editable?(user: users(:kevin))
  end

  test "create sets additional accesses" do
    sign_in :jason
    assert_difference -> { Blog.count }, +1 do
      post blogs_url, params: { blog: { title: "New Blog", everyone_access: false }, "editor_ids[]": users(:jz).id, "reader_ids[]": users(:kevin).id }
    end

    blog = Blog.last
    assert_equal "New Blog", blog.title
    assert_equal 3, Blog.last.accesses.count

    assert blog.editable?(user: users(:jz))

    assert blog.accessable?(user: users(:kevin))
    assert_not blog.editable?(user: users(:kevin))
  end

  test "show only shows blogs the current user can access" do
    get blog_slug_url(blogs(:manual))
    assert_response :not_found

    get blog_slug_url(blogs(:handbook))
    assert_response :success
  end

  test "show includes OG metadata for public access" do
    get blog_slug_url(blogs(:handbook))
    assert_response :success

    assert_select "meta[property='og:title'][content='Handbook']"
    assert_select "meta[property='og:url'][content='#{blog_slug_url(blogs(:handbook))}']"
  end
end
