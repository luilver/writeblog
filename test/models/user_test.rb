require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user does not prevent very long passwords" do
    users(:david).update(password: "secret" * 50)
    assert users(:david).valid?
  end

  test "new users get access to everyone blogs" do
    everyone_blog = Blog.create!(title: "My new blog", everyone_access: true)
    other_blog = Blog.create!(title: "My secret blog", everyone_access: false)

    bob = User.create!(email_address: "bob@example.com", name: "Bob", password: "secret123456")

    assert everyone_blog.accessable?(user: bob)
    assert_not everyone_blog.editable?(user: bob)

    assert_not other_blog.accessable?(user: bob)
  end
end
