require 'rubygems'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/warnable_models'
require 'activerecord'
require 'sqlite3'

# connect to database.  This will create one if it doesn't exist
MY_DB_NAME  = ".my.db"
MY_DB       = SQLite3::Database.new(MY_DB_NAME)

# get active record set up
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => MY_DB_NAME)

class CreateTestTable < ActiveRecord::Migration
  def self.up
    create_table 'names', :force => true do |t|
      t.string :first_name
      t.string :second_name, :limit => 20
    end
  end
  def self.down
    drop_table :names
  end
end

CreateTestTable.migrate(:down)
CreateTestTable.migrate(:up)

class Name < ActiveRecord::Base
  include Exelab::WarnableModels
  acts_as_warnable
  protected
  def run_warnings
    if self.first_name.size < 6
      warnings.add(:first_name, "First name too short")
    end
    if self.second_name.size > 8
      warnings.add(:second_name, "Second name too long")
    end
  end
end

class WarnableModelsTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_should_store_warning
    m = Name.new(:first_name => "Mario", :second_name => "Rossi")
    assert m.save
    assert m.warnings.on(:first_name)
    assert !m.warnings.on(:second_name)
    m.save
    assert m.warnings.size == 1, m.warnings.full_messages.inspect
    assert m.warnings.size == 1, m.warnings.full_messages.inspect
  end

  def test_should_not_increment_warnings_on_reload
    m = Name.new(:first_name => "Mario", :second_name => "Rossi")
    assert m.save
    assert m.warnings.on(:first_name)
    assert !m.warnings.on(:second_name)
    assert m.warnings.size == 1
    # m.run_warnings
    assert m.warnings.size == 1, m.warnings.full_messages
  end

  def test_should_not_call_run_warnings 
    m = Name.new(:first_name => "Mario", :second_name => "Rossi")    
    assert m.save 
    begin       
      m.run_warnings
    rescue NoMethodError => e
      assert true
    rescue => e 
      raise e 
    end
  end
  
  # def test_multiple_warnings
  #   m = Name.new
  #   warning1 = "this is a test warning."
  #   warning2 = "this is a second test warning."
  #   m.warnings.add(:test, warning1)
  #   m.warnings.add(:test, warning2)
  #   assert m.warnings.size > 0
  #   assert m.warnings.on(:test) == [warning1, warning2]
  # end

end
