require "test_helper"

class BlogTest < ActiveSupport::TestCase
  test "slug is generated from title" do
    blog = Blog.create!(title: "Hello, World!")
    assert_equal "hello-world", blog.slug
  end

  test "press a leafable" do
    leaf = blogs(:manual).press Page.new(body: "Important words"), title: "Introduction"

    assert leaf.page?
    assert_equal "Important words", leaf.page.body.content.to_s
    assert_equal "Introduction", leaf.title
  end
end
