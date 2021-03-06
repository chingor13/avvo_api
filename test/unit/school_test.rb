require 'test_helper'

class AvvoApi::SchoolTest < Test::Unit::TestCase

  context "AvvoApi::School" do
    should "belong_to :lawyer" do
      assert_contains(AvvoApi::School.belongs_to_associations.map(&:attribute), :lawyer)
    end
    should "belong_to :doctor" do
      assert_contains(AvvoApi::School.belongs_to_associations.map(&:attribute), :doctor)
    end
  end

end
