require "test_helper"

class Collection::WorkflowingTest < ActiveSupport::TestCase
  test "change all card stages when changing workflow" do
    collections(:writebook).update! workflow: workflows(:on_call)
    assert_equal [ collections(:writebook).initial_workflow_stage ], collections(:writebook).cards.reload.collect(&:stage).uniq
  end
end
