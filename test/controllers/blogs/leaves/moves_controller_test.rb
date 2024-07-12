require "test_helper"

class Blogs::Leaves::MovesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kevin
  end

  test "moving a single item" do
    assert_equal [ leaves(:welcome_section), leaves(:welcome_page), leaves(:summary_page), leaves(:reading_picture) ], blogs(:handbook).leaves.positioned

    post blog_leaves_moves_url(blogs(:handbook), id: leaves(:welcome_page).id, position: 0)
    assert_response :no_content

    assert_equal [ leaves(:welcome_page), leaves(:welcome_section), leaves(:summary_page), leaves(:reading_picture) ], blogs(:handbook).leaves.positioned
  end

  test "moving multiple items" do
    assert_equal [ leaves(:welcome_section), leaves(:welcome_page), leaves(:summary_page), leaves(:reading_picture) ], blogs(:handbook).leaves.positioned

    post blog_leaves_moves_url(blogs(:handbook), id: leaves(:summary_page, :reading_picture).map(&:id), position: 1)
    assert_response :no_content

    assert_equal [ leaves(:welcome_section), leaves(:summary_page), leaves(:reading_picture), leaves(:welcome_page) ], blogs(:handbook).leaves.positioned
  end
end
