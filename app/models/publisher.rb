# == Schema Information
# Schema version: 20110410134111
#
# Table name: publishers
#
#  id         :integer(38)     not null, primary key
#  created_at :timestamp(6)
#  updated_at :timestamp(6)
#  name       :string(1020)    not null
#  country    :string(1020)
#

class Publisher < ActiveRecord::Base
  has_many :imprints
  
  has_many :supplierdiscounts
  has_many :suppliers, :through => :supplierdiscounts
end
