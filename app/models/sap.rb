require 'csv'
module SAP
  EXPORT_FORMATS = {
    :LSMW => "LSMW",
    :FG => "FG"
  }
  
  def self.create_file(klass, filename)
    case filename
      when EXPORT_FORMATS[:LSMW] then csv = lsmw(klass.ready_for_sap.where(:sap_rm => 'N').order(:id).limit(1000))
      when EXPORT_FORMATS[:FG] then csv = fg(klass.ready_for_sap.where(:sap_fg => 'N').order(:id).limit(1000))
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
  
  def self.sap_matkl(language_name, category_id)
    language = Language.find_by_name(language_name)
    category = Category.find_by_id(category_id)
    return language.sap_matkl unless language.try(:sap_matkl).nil?
    category.try(:sap_matkl)
  end
  
  def self.sap_ekgrp(language_name, category_id)
    language = Language.find_by_name(language_name)
    category = Category.find_by_id(category_id)
    return language.sap_ekgrp unless language.try(:sap_ekgrp).nil?
    category.try(:sap_ekgrp)
  end
  
    

  def self.sanitize_string(str)
    return "" if str.nil?
    str.gsub(/[\'|\,|\|\t"]/,"")
  end
end