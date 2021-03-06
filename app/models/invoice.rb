# == Schema Information
# Schema version: 20110728072757
#
# Table name: invoices
#
#  id              :integer(38)     not null, primary key
#  invoice_no      :string(255)     not null
#  po_id           :integer(38)     not null
#  date_of_receipt :timestamp(6)    not null
#  quantity        :integer(38)     not null
#  amount          :decimal(, )     not null
#  created_at      :timestamp(6)
#  updated_at      :timestamp(6)
#  boxes_cnt       :integer(38)     not null
#  date_of_invoice :timestamp(6)    not null
#  created_by      :integer(38)
#  modified_by     :integer(38)
#  has_isbn        :string(20)      default("YES")
#

require 'barby'
require 'barby/outputter/png_outputter'

class Invoice < ActiveRecord::Base
  belongs_to :po, :counter_cache => true
  
  validates :invoice_no,              :presence => true
  validates :po_id,                   :presence => true
  validates :date_of_receipt,         :presence => true
  validates :date_of_invoice,         :presence => true
  validates :quantity,                :presence => true, :numericality => { :greater_than => 0, :only_integer => true }
  validates :amount,                  :presence => true, :numericality => { :greater_than => 0 }
  validates :boxes_cnt,               :presence => true, :numericality => { :greater_than => 0, :only_integer => true }
  validates :has_isbn,                :presence => true  
  validate  :po_val_greater_than_total_invoices_val, :quantity_under_capacity
  
  validate  :received_cnt_for_destroy, :on => :destroy
  
  
  has_many :boxes
  has_many :invoiceitems
  has_many :bookreceipts

  before_create :clean_invoice_no
  after_create :generate_barcodes
  after_create :create_boxes
  before_destroy :destroy_boxes
  
  scope :today, lambda { where("created_at >= ? and created_at <= ?",  Time.zone.today.to_time.beginning_of_day, Time.zone.today.to_time.end_of_day) }
  scope :created_on, lambda {|date| 
      {:conditions => ['created_at >= ? AND created_at <= ?', Time.zone.date.to_time.beginning_of_day, Time.zone.date.to_time.end_of_day]} 
    }
  scope :created_between, lambda {|startdate, enddate| 
      {:conditions => ['created_at >= ? AND created_at <= ?', startdate, enddate]}
    }
  scope :invoice_date_between, lambda {|startdate, enddate| 
      {:conditions => ['date_of_invoice >= ? AND date_of_invoice <= ?', startdate, enddate]}
    }
  scope :recent, lambda {
      where('created_at >= ?', 7.days.ago).
      order('id DESC')
    }
  scope :of_po_and_invoice, lambda { |po_id, invoice_no|
      where('po_id = ? AND invoice_no = ?', po_id, invoice_no)
    }
  
  def isbn_invoice?
    has_isbn.eql?('YES')
  end
  
  def nls_invoice?
    !isbn_invoice?
  end
  
  def formatted_po_name
    po.code[0..po.code.index('/',5)-1]
  end
  
  def formatted_po_file_name
    po.code[0..po.code.index('/',5)-1].gsub(/\//,'_')
  end
  
  def formatted_invoice_name
    invoice_no.gsub(/\//,'_')
  end
  
  def regenerate
    generate_barcodes
  end
  
  def self.filter_by_invoice_date(params)
    created = params[:raised]
    if created == 'All'
      Invoice.paginate(:per_page => 250, :page => params[:page])
    else
      start_d_s = params[:start]
      end_d_s = params[:end]
      start_s = ""
      end_s = ""
      
      if (!start_d_s.nil?)
        start_s = start_d_s["start(3i)"] + '-' + start_d_s["start(2i)"] +'-'+ start_d_s["start(1i)"]
      end
      if (!end_d_s.nil?)
        end_s = end_d_s["end(3i)"] + '-' + end_d_s["end(2i)"] +'-'+ end_d_s["end(1i)"]
      end
      
      start_date = Time.zone.today.beginning_of_day
      end_date =  Time.zone.today.end_of_day
      
      if created == 'Today'
        start_date = Time.zone.today.beginning_of_day
        end_date =  Time.zone.today.end_of_day
      elsif created == 'Range'
        start_date = start_s.to_time.beginning_of_day
        end_date =  end_s.to_time.beginning_of_day
      elsif created == 'On'
        start_date = start_s.to_time.beginning_of_day
        end_date =  start_s.to_time.end_of_day
      end
      
      Invoice.invoice_date_between(start_date, end_date).paginate(:per_page => 250, :page => params[:page])
    end   
  end
  
  def self.filter_by_entry_date(params)
    created = params[:entered]
    if created == 'All'
      Invoice.paginate(:per_page => 250, :page => params[:page])
    else
      start_d_s = params[:start]
      end_d_s = params[:end]
      start_s = ""
      end_s = ""
      
      if (!start_d_s.nil?)
        start_s = start_d_s["start(3i)"] + '-' + start_d_s["start(2i)"] +'-'+ start_d_s["start(1i)"]
      end
      if (!end_d_s.nil?)
        end_s = end_d_s["end(3i)"] + '-' + end_d_s["end(2i)"] +'-'+ end_d_s["end(1i)"]
      end
      
      start_date = Time.zone.today.beginning_of_day
      end_date =  Time.zone.today.end_of_day
      
      if created == 'Today'
        start_date = Time.zone.today.beginning_of_day
        end_date =  Time.zone.today.end_of_day
      elsif created == 'Range'
        start_date = start_s.to_time.beginning_of_day
        end_date =  end_s.to_time.beginning_of_day
      elsif created == 'On'
        start_date = start_s.to_time.beginning_of_day
        end_date =  start_s.to_time.end_of_day
      end
      
      Invoice.created_between(start_date, end_date).paginate(:per_page => 250, :page => params[:page])
    end   
  end
  
  def destroy
    #raise Exceptions::InvoiceInUse unless Titlereceipt.of_invoice(invoice_no).count == 0
    if Titlereceipt.of_invoice(invoice_no).count != 0
      return false
    else
      super
      return true
    end
  end
  
  def get_bookreceipts_invoiceitems
    sql_stmt = "select b.isbn isbn, count(b.isbn) cnt, ii.isbn ii_isbn, ii.quantity quantity, "+
                              " decode( (count(b.isbn) - ii.quantity), 0, 'Same',-1, 'Over',1, 'Under', 'diff') diff" +
                              " from invoiceitems ii, bookreceipts b where ii.invoice_id = b.invoice_id " +
                              " and trim(ii.isbn) = trim(b.isbn) "+
                              " and b.invoice_id= #{self.id.to_s} and ii.invoice_id= #{self.id.to_s} group by b.isbn, ii.isbn, ii.quantity "
    bookreceipt_invoiceitems = Bookreceipt.find_by_sql(sql_stmt)
  end
  
  def get_extra_bookreceipts 
    sql_stmt =  "SELECT '' isbn, 0 cnt, ii.isbn ii_isbn, ii.quantity quantity, 'Over' diff" +
                    " FROM invoiceitems ii " +
                    " WHERE (ii.invoice_id , trim(ii.isbn) ) NOT IN "+
                      "(SELECT  invoice_id, trim(isbn) FROM bookreceipts WHERE invoice_id = #{self.id.to_s}) "+
                       " AND invoice_id = #{self.id.to_s} "+ 
                    " GROUP BY '', 0, ii.isbn, ii.quantity "                
    bookreceipts = Invoiceitem.find_by_sql(sql_stmt)
  end
  
  def get_extra_invoiceitems
    sql_stmt =  "SELECT b.isbn isbn, COUNT(b.isbn) cnt,'' ii_isbn, 0 quantity, 'Under' diff"+
                " FROM Bookreceipts b  WHERE (b.invoice_id , trim(b.isbn) ) NOT IN "+
                " (select  invoice_id, trim(isbn) FROM invoiceitems WHERE "+
                " invoice_id = #{self.id.to_s}) "+
                " AND invoice_id = #{self.id.to_s} "+
                " GROUP BY  b.isbn, '',0 " +
                " ORDER BY 2 DESC "
    bookreceipts = Bookreceipt.find_by_sql(sql_stmt)
  end
  
  private 
    
    def clean_invoice_no
      self.invoice_no = self.invoice_no.upcase.chomp.strip
    end

    def generate_barcodes
      postr = formatted_po_name
      pofilename = formatted_po_file_name
      invstr = formatted_invoice_name
      
      pobarcode = Barby::Code128B.new(postr)
      invbarcode = Barby::Code128B.new(invoice_no)

      File.open('public/images/' + pofilename + '.png', 'wb') do |f|
        f.write pobarcode.to_png
      end
      File.open('public/images/' + invstr + '.png', 'wb') do |f|
        f.write invbarcode.to_png
      end
    end
    
    def quantity_under_capacity
      self.received_cnt ||= 0
      errors.add(:received_cnt, "Order Quantity Exceeded") if received_cnt > quantity
    end
    
    def po_val_greater_than_total_invoices_val
      po_temp = Po.find(po_id)
      unless id.nil?
        inv = Invoice.find(id) #Fetch the already saved record if any
      end
      if po_temp
        #Take current invoice value into consideration
        unless inv.nil?
          #Existing Invoice entry
          total_util_so_far = po_temp.invoices.collect{|x| x.amount}.sum - inv.amount
          total_qty_so_far = po_temp.invoices.collect{|x| x.quantity}.sum - inv.quantity
        else
          #New Invoice entry
          total_util_so_far = po_temp.invoices.collect{|x| x.amount}.sum
          total_qty_so_far = po_temp.invoices.collect{|x| x.quantity}.sum
        end
        
        if total_util_so_far + amount > po_temp.netamt
          errors.add(:amount, " - Total invoices amount exceeds PO value")
        elsif total_qty_so_far + quantity > po_temp.copies_cnt
          errors.add(:quantity, " - Total invoices quantity exceeds PO copies")
        end
      end
    end
    
    def create_boxes
      boxes_cnt.times do |i|
        self.boxes.build(:box_no => i+1, :po_no => po.code, :invoice_no => invoice_no).save!        
      end
    end
    
    def destroy_boxes
      self.boxes.each do |box|
        box.destroy
      end
    end
    
    def received_cnt_for_destroy
      errors.add(:id, "Invoice already processed - cannot delete") if received_cnt > 0
      boxes.each do |box|
        errors.add(:id, "Invoice already processed - cannot delete") if box.total_cnt > 0
      end
    end
end
