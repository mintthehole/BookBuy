# == Schema Information
# Schema version: 20110410134111
#
# Table name: suppliers
#
#  id             :integer(38)     not null, primary key
#  name           :string(100)
#  contact        :string(100)
#  phone          :string(100)
#  city           :string(100)
#  typeofshipping :integer(38)
#  discount       :integer(38)
#  creditperiod   :integer(38)
#

class Supplier < ActiveRecord::Base
  attr_accessible :publisher_ids
  has_many :supplierdiscounts
  has_many :publishers, :through => :supplierdiscounts
  has_many :pos
end
