# Include hook code here
require 'warnable_models.rb'
require 'warnable_helper.rb'

ActiveRecord::Base.send :include, Freegenie::WarnableModels
ActionView::Base.send   :include, Freegenie::WarnableHelper

