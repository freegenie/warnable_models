
# ---------------------
# database setup 
# ---------------------

# connect to database.  This will create one if it doesn't exist
MY_DB_NAME  = ".my.db"
MY_DB       = SQLite3::Database.new(MY_DB_NAME)

# get active record set up
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => MY_DB_NAME)

class CreateTestTable < ActiveRecord::Migration  
  def self.up
    create_table 'books', :force => true do |t|
      t.string :title
      t.string :author
      t.text :description
      t.text :warnings 
    end
    
    create_table 'accounts', :force => true do |t|
      t.float :balance
      t.integer :warnings_count
      t.text :verbose_warnings
    end
    
  end
  
  def self.down
    drop_table :books
    drop_table :accounts
  end
  
end

begin
  CreateTestTable.migrate(:down)
rescue   
end
CreateTestTable.migrate(:up)

# ---------------------
# model setup 
# ---------------------

class Book < ActiveRecord::Base  
  include Freegenie::WarnableModels  
  acts_as_warnable    
  protected  
  def run_warnings        
    if self.description.nil? || self.description.size < 10 
      warnings.add(:description, "Description is probably too short.")
    end
    if self.author.blank? 
      warnings.add(:author, "Did you forget the author?")
    end
  end
  
end

class Account < ActiveRecord::Base 
  BALANCE_WARNING = "Should warn the customer?"
  include Freegenie::WarnableModels
  acts_as_warnable :store_count => :warnings_count, :store_yaml => :verbose_warnings
  protected 
  def run_warnings 
    if self.balance.to_i < 0 
      warnings.add(:balance, BALANCE_WARNING)
    end
  end  
end
