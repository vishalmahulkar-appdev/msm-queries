# == Schema Information
#
# Table name: directors
#
#  id         :integer          not null, primary key
#  bio        :text
#  dob        :integer
#  image      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Director < ApplicationRecord
    def Director.youngest
        return Director.order({:dob => :asc}).last
    end

    def Director.eldest
        return Director.order({:dob => :asc}).where.not({:dob => nil}).first
    end

    def filmography
        return Movie.where({ :director_id => self.id })
    end
end
