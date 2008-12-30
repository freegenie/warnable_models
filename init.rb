# Include hook code here
require 'warnable_models.rb'
ActiveRecord::Base.send :include, Exelab::WarnableModels