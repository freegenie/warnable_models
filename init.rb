# Include hook code here
require 'warnable_models.rb'
require 'warnable_helper.rb'

ActiveRecord::Base.send :include, Exelab::WarnableModels
ActionView::Base.send   :include, Exelab::WarnableHelper

