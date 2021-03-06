# == Schema Information
# Schema version: 20110410134111
#
# Table name: supplierdiscounts
#
#  id           :integer(38)     not null, primary key
#  publisher_id :integer(38)     not null
#  supplier_id  :integer(38)     not null
#  discount     :decimal(, )
#  created_at   :timestamp(6)
#  updated_at   :timestamp(6)
#  bulkdiscount :decimal(, )
#

class Supplierdiscount < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :supplier
  
  scope :to_fill, where("discount is NULL or bulkdiscount is NULL")
  scope :to_fill_in_procurement_det, lambda {|procurement_id|
      joins([:supplier => {:procurementitems => :procurement}], [:publisher => {:imprints => {:enrichedtitles => {:procurementitems => :procurement}}}]).
      where(:procurements => {:id => procurement_id}).
      where("supplierdiscounts.discount IS NULL OR supplierdiscounts.bulkdiscount IS NULL")
    }
  scope :to_fill_in_procurement, lambda {|procurement_id|
      where(:id => to_fill_in_procurement_det(procurement_id).collect {|discount| discount.id}.uniq).
      where(:publisher_id => Procurement.find(procurement_id).pos.collect {|po| po.publisher_id}.uniq)
    }
  scope :of_procurement_det, lambda {|procurement_id|
    joins([:supplier => {:procurementitems => :procurement}], [:publisher => {:imprints => {:enrichedtitles => {:procurementitems => :procurement}}}]).
      where(:procurements => {:id => procurement_id})
  }
  scope :of_procurement, lambda {|procurement_id|
      where(:id => of_procurement_det(procurement_id).collect {|discount| discount.id}.uniq).
      where(:publisher_id => Procurementitem.to_order_in_procurement(procurement_id).collect {|item| item.enrichedtitle.imprint.publisher.id}.uniq)
    }
end
