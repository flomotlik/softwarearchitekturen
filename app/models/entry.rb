class Entry < ActiveRecord::Base
  #Helper attribute for search
  attr_accessor :search_hit
end
