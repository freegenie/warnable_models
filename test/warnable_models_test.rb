require 'test/unit'
require 'warnable_models'

class MyTestModel
  include Exelab::WarnableModels
  acts_as_warnable
end

class WarnableModelsTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_this_plugin
    m=MyTestModel.new
    text = "this is a test warning."
    m.warn(:test, text)
    assert m.has_warnings?
    assert m.warnings[:test] = text
  end
end
