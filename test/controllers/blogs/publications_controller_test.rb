require "test_helper"

class Blogs::PublicationsTest < ActionDispatch::IntegrationTest
  setup do
    @blog = blogs(:manual)

    sign_in :david
  end

  test "publish a blog" do
    assert_changes -> { @blog.reload.published? }, from: false, to: true do
      patch blog_publication_url(@blog), params: { blog: { published: "1" } }
    end

    @blog.reload
    assert_redirected_to blog_slug_url(@blog)
    assert_equal "manual", @blog.slug
  end

  test "edit blog slug" do
    @blog.update! published: true

    get edit_blog_publication_url(@blog)
    assert_response :success

    patch blog_publication_url(@blog), params: { blog: { slug: "new-slug" } }

    @blog.reload
    assert_redirected_to blog_slug_url(@blog)
    assert_equal "new-slug", @blog.slug
  end
end
