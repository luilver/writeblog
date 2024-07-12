require "test_helper"

class FirstRunTest < ActiveSupport::TestCase
  setup do
    Blog.destroy_all
    User.destroy_all
    Account.destroy_all
  end

  test "creating makes first user an administrator" do
    user = create_first_run_user
    assert user.administrator?
  end

  test "creates an account" do
    assert_changes -> { Account.count }, +1 do
      create_first_run_user
    end
  end

  test "creates a demo blog" do
    assert_changes -> { Blog.count }, to: 1 do
      create_first_run_user
    end

    blog = Blog.first

    assert blog.editable?(user: User.first)
    assert blog.cover.attached?
    assert blog.leaves.any?
  end

  private
    def create_first_run_user
      FirstRun.create!({ name: "User", email_address: "user@example.com", password: "secret123456" })
    end
end
