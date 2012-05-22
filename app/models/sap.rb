require 'csv'
module SAP
  
  DEFAULT_MATKL = "9000"
  DEFAULT_EKGRP = "P20" 

  EXPORT_FORMATS = {
    :LSMW => "LSMW",
    :FG => "FG",
    :FGEXT => "FGEXT",
    :BOM => 'BOM'
  }
  
  def self.create_file(klass, params)
    filename = params[:file_id]
    language = params[:language]
    case filename
      when EXPORT_FORMATS[:LSMW] then csv = lsmw(klass.ready_for_sap.where(:sap_rm => 'N').where(:language => language).order(:id).limit(1000))
      when EXPORT_FORMATS[:FG] then csv = fg(klass.ready_for_sap.where(:sap_fg => 'N').where(:language => language).order(:id).limit(1000))
      when EXPORT_FORMATS[:FGMM] then csv = fgmm(klass.ready_for_sap.where(:sap_fg => 'N').where(:language => language).order(:id).limit(1000))
      when EXPORT_FORMATS[:FGEXT] then csv = fgext(klass.ready_for_sap.where(:sap_fg => 'N').where(:language => language).order(:id).limit(1000))
      when EXPORT_FORMATS[:BOM] then csv = bom(klass.ready_for_sap.where(:sap_fg => 'N').where(:language => language).order(:id).limit(1000))
      else csv = "INVALID FILE #{filename}"
    end
    csv
  end
  
#  private
  
  def self.lsmw(et_or_nt)
    CSV.generate(:col_sep => "\t") do |line|
      line << %w[MATNR WERKS LGORT LGNUM MAKTX MATKL BISMT EXTWG BRGEW GEWEI GROES NORMT ZEINR ZEIVR AESZN ZEIFO EKGRP MFRPN MFRNR DISPO BKLAS VERPR PRCTR]
      
      et_or_nt.each do |t|
        
        line << ["R#{t.sap_matnr}",
                 "M001",
                 "S001",
                 "BLR",
                 sanitize_string(t.title).slice(0,40),
                 sap_matkl(t.language, t.category_id),
                 t.title_id,
                 t.pub_year,
                 t.weight_in_grams,
                 "G",
                 t.dimensions,
                 t.language,
                 sanitize_string(t.sap_zeinr),
                 " ",
                 t.page_cnt,
                 "PB",
                 sap_ekgrp(t.language, t.category_id),
                 sanitize_string(t.author).slice(0,40),
                 " ",
                 "000",
                 "3000",
                 t.inr_price,
                 "SJB"                 
          ]
      end
    end
  end

  def self.fg(et_or_nt)
    CSV.generate(:col_sep => "\t") do |line|
      line << %w[MATNR MAKTX MATKL BISMT EXTWG BRGEW GEWEI GROES NORMT ZEINR ZEIVR AESZN ZEIFO EKGRP MFRPN MFRNR STPRS]
      
      et_or_nt.each do |t|
        
        line << ["F#{t.sap_matnr}",
                 sanitize_string(t.title).slice(0,40),
                 sap_matkl(t.language, t.category_id),
                 t.title_id,
                 t.pub_year,
                 t.weight_in_grams,
                 "G",
                 t.dimensions,
                 t.language,
                 sanitize_string(t.sap_zeinr),
                 " ",
                 t.page_cnt,
                 "PB",
                 sap_ekgrp(t.language, t.category_id),
                 sanitize_string(t.author).slice(0,40),
                 " ",
                 " "
          ]
      end
    end
  end
  
  def self.fgmm(et_or_nt)
    CSV.generate(:col_sep => "\t") do |line|
      line << %w[MATNR WERKS LGORT MAKTX MATKL BISMT EXTWG BRGEW GEWEI GROES NORMT ZEINR ZEIVR AESZN ZEIFO EKGRP MFRPN]
      
      et_or_nt.each do |t|
        
        line << ["F#{t.sap_matnr}",
                 "M001",
                 "S005",
                 sanitize_string(t.title).slice(0,40),
                 sap_matkl(t.language, t.category_id),
                 t.title_id,
                 t.pub_year,
                 t.weight_in_grams,
                 "G",
                 t.dimensions,
                 t.language,
                 sanitize_string(t.sap_zeinr),
                 " ",
                 t.page_cnt,
                 "PB",
                 sap_ekgrp(t.language, t.category_id),
                 sanitize_string(t.author).slice(0,40)
          ]
      end
    end
  end
  
  def self.fgext(et_or_nt)
    CSV.generate(:col_sep => "\t") do |line|
      line << %w[MATNR WERKS LGORT MAKTX PRCTR EKGRP STPRS]
      
      et_or_nt.each do |t|
        
        sap_plants.each do |p|        
          line << ["F#{t.sap_matnr}",
                   sap_lgort(p),
                   "SB04",
                   sanitize_string(t.title).slice(0,40),
                   sap_prctr(p),
                   sap_ekgrp(t.language, t.category_id),
                   " "
            ]
        end
      end
    end
  end
  
  def self.bom(et_or_nt)    
    mms = ["RJACDUMMY", "500000", "500006", "500001"]
    
    CSV.generate(:col_sep => "\t") do |line|
      line << %w[MATNR WERKS STLAN STLAL DATUV BMENG STLST POSNR POSTP IDNRK MENGE SANKA]

      et_or_nt.each do |t|

        line << ["F#{t.sap_matnr}",
                 "M001",
                 "1",
                 "1",
                 "03.05.2012",
                 "1",
                 "1",
                 "10",
                 "L",
                 "R#{t.sap_matnr}",
                 "1",
                 "X"
          ]
      
        
        4.times do |p|        
          line << [" ",
                   " ",
                   " ",
                   " ",
                   " ",
                   " ",
                   " ",
                   ((p+2) * 10).to_s,
                   "L",
                   mms[p],
                   "1",
                   "X"
            ]
        end
      end
    end    
  end
  
  def self.sap_matkl(language_name, category_id)
    language = Language.find_by_name(language_name)
    category = Category.find_by_id(category_id)
    return language.sap_matkl unless language.try(:sap_matkl).nil?
    matkl = category.try(:sap_matkl)
    matkl ||= DEFAULT_MATKL
  end
  
  def self.sap_ekgrp(language_name, category_id)
    language = Language.find_by_name(language_name)
    category = Category.find_by_id(category_id)
    return language.sap_ekgrp unless language.try(:sap_ekgrp).nil?
    ekgrp = category.try(:sap_ekgrp)
    ekgrp ||= DEFAULT_EKGRP
  end

  def self.sap_lgort(branch_id)
    "F#{branch_id.to_s.rjust(3, "0")}"
  end
  
  def self.sap_prctr(branch_id)
    return "SMU" if branch_id == 62
    "SJB"
  end    

  def self.sanitize_string(str)
    return "" if str.nil?
    str.gsub(/[\'|\,|\|\t"]/,"")
  end
  
  def self.sap_plants
    plants = (68..68).to_a
#    plants << 68
    plants << 952
#    plants.delete(28)
    plants
  end
  
end