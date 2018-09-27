class Movie < ActiveRecord::Base
 def self.all_ratings
  self.select(:rating).map(&:rating).uniq
 end
end
