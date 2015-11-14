class Movie < ActiveRecord::Base
    def self.MPAARatings
        ratings = {'G'=>'1','PG'=>'1','PG-13'=>'1','R'=>'1'}
        return ratings
    end
end
