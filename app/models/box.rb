# == Schema Information
# Schema version: 20110410134111
#
# Table name: boxes
#
#  id         :integer(38)     not null, primary key
#  box_no     :integer(38)     not null
#  po_no      :string(255)     not null
#  invoice_no :string(255)     not null
#  total_cnt  :integer(38)
#  created_at :timestamp(6)
#  updated_at :timestamp(6)
#  crate_id   :integer(38)
#

class Box < ActiveRecord::Base
  CAPACITY = 100;
  
  belongs_to :crate
  belongs_to :po, :primary_key => "code", :foreign_key => "po_no"
  
  validate :exceeds_capacity
  
  scope :unassigned, where("crate_id IS NULL").order("id")
  scope :unassigned_among_pos, lambda { |po_nos|
    where(:po_no => po_nos).order("id")
    }
  scope :unassigned_in_po_and_invoice, lambda { |po_no, invoice_no|
    where("crate_id IS NULL AND po_no = ? and invoice_no = ?", po_no, invoice_no)
    }  
  scope :is_assigned, lambda { |crate_id|
    where("crate_id = :crate_id", :crate_id => crate_id)
    }
  
  def get_supplier_name
    Po.find_by_code(po_no).supplier.name
  end
  
  def self.fill_crate(crate_id)
    current_cnt = 0
    added_boxes = Array.new
    
    if Box.unassigned.count > 0
      boxes = Box.unassigned.first.po_no
    end
    
    if boxes
      supplier_id = Po.find_by_code(boxes).supplier_id
      unassigned_boxes = Box.joins(:po).where("crate_id IS NULL and pos.supplier_id = ?", supplier_id).order('boxes.id').readonly(false)
      # Box.unassigned.unassigned_among_pos(Po.pos_for_supplier(Po.find_by_code(boxes).supplier_id).collect {|po| po.code})
      
      #More Intelligence
      #1. Get the Biggest boxes first
      #2. The first box might be lesser than capacity, but the next may be more than capacity
      
      #If first crate has more books than capacity
      if unassigned_boxes.first.total_cnt > Crate::CAPACITY
        box = unassigned_boxes.first
        current_cnt = current_cnt + box.total_cnt
        added_boxes.push(box)
      #else loop and fill crate
      else
        unassigned_boxes.each do |box|
          if current_cnt + box.total_cnt <= Crate::CAPACITY
            current_cnt = current_cnt + box.total_cnt
            added_boxes.push(box)
          end
        end
      end
      
      #Create entries for Crate and update crate_id in Boxes
      if current_cnt > 0
        #Assign box to crate
        added_boxes.each do |added_box|
          added_box.crate_id = crate_id
          added_box.save!
        end
        
        #Update Crate with Total Items
        crate = Crate.find(crate_id)
        crate.total_cnt = current_cnt
        crate.save!
      end
    end
  end
  
  private
    def exceeds_capacity
      if total_cnt > Box::CAPACITY
        errors.add(:quantity, " : 100 Books have already been recieved in this Box. Use Another Box!");
      end
    end   
end
