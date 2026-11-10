require "test_helper"

class SynonymTest < ActiveSupport::TestCase
  test "should not save synonym without name" do
    synonym = Synonym.new
    assert_not synonym.save, "Saved the synonym without a name"
  end

  test "should not save synonym with same name for the same word" do
    word = words(:one)
    synonym = Synonym.new(name: "MyString", word: word)
    assert_not synonym.save, "Saved a synonym with the same name for the same word"
  end
end
