require 'test/unit'
require 'warnable_models'

class MyTestModel
  include Exelab::WarnableModels
  acts_as_warnable
end

class WarnableModelsTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_warnings_store
    m=MyTestModel.new
    text = "this is a test warning."
    m.warnings.add(:test, text)
    assert m.warnings.size > 0 
    assert m.warnings.on(:test) == text
  end
  
  def test_multiple_warnings 
    m=MyTestModel.new
    warning1 = "this is a test warning."
    warning2 = "this is a second test warning."    
    m.warnings.add(:test, warning1)
    m.warnings.add(:test, warning2)
    assert m.warnings.size > 0 
    assert m.warnings.on(:test) == [warning1, warning2]
  end

end
