require 'rubygems'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/warnable_models'
require 'activerecord'
require 'sqlite3'
require 'redgreen'
require 'shoulda'

require 'test/setup'

class WarnableModelsTest < Test::Unit::TestCase
  
  def setup
    Account.delete_all 
    Book.delete_all 
  end    

  should "store warnings" do 
    m = Book.new(:title => "Warnable models")
    assert m.save
    assert m.warnings.on(:author)
    assert m.warnings.on(:description)
    assert m.warnings.size == 2, m.warnings.full_messages.inspect
  end
  
  should "not increment warnings count on warnings reload" do 
    m = Book.new(:title => "Warnable models", :author => "John Doe")
    assert m.save
    assert !m.warnings.on(:title)
    assert m.warnings.on(:description)
    m.warnings # this can be called multiple times
    assert m.warnings.size == 1
    assert m.warnings.size == 1, m.warnings.full_messages
  end
  
  should "store multiple warnings for each column" do         
    m = Book.new
    warning1 = "this is a test warning."
    warning2 = "this is a second test warning."
    m.warnings.add(:test, warning1)
    m.warnings.add(:test, warning2)
    assert m.warnings.size > 0
    assert m.warnings.on(:test) == [warning1, warning2]
  end
  
  should "store numeric field into database for warnings" do     
    account = Account.new(:balance => -10.0)
    assert account.warnings.size > 0         
    assert account.save        
    account = Account.find(:first)
    assert account.warnings_count == 1  
  end  
  
  should "store warnings as yaml into database" do     
    account = Account.new(:balance => -10.0)
    assert account.save 
    assert account.warnings.size > 0        
    account = Account.find(:first)
    assert YAML::load(account.verbose_warnings)["balance"].include? Account::BALANCE_WARNING
  end  
  
  should "free warnings database fields when warnings are gone" do 
    account = Account.new(:balance => -10.0)
    assert account.save 
    assert account.warnings.size > 0        
    account.balance = 10.0 
    account.save 
    assert account.warnings_count == 0 
    assert account.verbose_warnings.blank?, account.verbose_warnings.inspect
  end
  
  should "eval warnings on a live record" do 
    account = Account.new(:balance => -10.0)
    assert account.warnings.size > 0        
    account.balance = 10.0 
    account.clear_warnings!
    assert account.warnings.size == 0
    assert account.warnings_count == 0, account.warnings_count.inspect
    assert account.verbose_warnings.blank?
  end
  
end
