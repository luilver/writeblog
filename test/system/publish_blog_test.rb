require "application_system_test_case"

class PublishTest < ApplicationSystemTestCase
  setup do
    sign_in "kevin@37signals.com"
  end

  test "create and publish a blog" do
    visit new_blog_url

    fill_in "Blog title", with: "My Blog of Jokes"
    fill_in "Author", with: "Kevin"
    within "footer" do
      click_button
    end

    assert_text "My Blog of Jokes"

    click_on "Add a new section page"
    fill_in "leaf_title", with: "A horse walks into a bar"
    click_on "Save"

    click_on "Add a new section page"
    fill_in "leaf_title", with: "And the barman says 'Why the long face?'"
    click_on "Save"

    find(class: "switch__btn").click
    public_url = find(id: "invite_url").value

    using_session "public" do
      visit public_url
      assert_text "My Blog of Jokes"

      page.send_keys :arrow_right
      assert_text "A horse walks into a bar"
    end
  end
end
