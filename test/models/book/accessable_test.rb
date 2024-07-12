require "test_helper"

class Blog::AccessableTest < ActiveSupport::TestCase
  test "update_access always grants read access to everyone when everyone_access is set" do
    blog = Blog.create!(title: "My new blog")
    blog.update_access(editors: [], readers: [])

    assert blog.everyone_access?

    User.all.each do |user|
      assert blog.accessable?(user: user)
      assert_not blog.editable?(user: user) unless user.administrator?
    end
  end

  test "update_access updates existing access" do
    blog = Blog.create!(title: "My new blog", everyone_access: false)

    blog.update_access(editors: [ users(:kevin).id ], readers: [])
    assert blog.editable?(user: users(:kevin))

    blog.update_access(editors: [], readers: [ users(:kevin).id ])
    assert blog.accessable?(user: users(:kevin))
    assert_not blog.editable?(user: users(:kevin))
  end

  test "update_access removes stale accesses" do
    blog = Blog.create!(title: "My new blog", everyone_access: false)

    blog.update_access(editors: [ users(:kevin).id ], readers: [ users(:jz).id ])
    assert_equal 2, blog.accesses.size

    blog.update_access(editors: [ users(:kevin).id ], readers: [])
    assert_equal 1, blog.accesses.size
  end
end
