require 'csv'
module SAP
  EXPORT_FORMATS = {
    :LSMW => "LSMW",
    :FG => "FG"
  }
  
  def self.create_file(filename)
    case filename
      when EXPORT_FORMATS[:LSMW] then csv = lsmw(Enrichedtitle.limit(10))
      when EXPORT_FORMATS[:FG] then csv = fg(Enrichedtitle.limit(10))
      else csv = "INVALID FILE #{filename}"
    end
    csv
  end
  
#  private
  
  def self.lsmw(ets)
    CSV.generate(:col_sep => "\t") do |line|
      line << %w[MATNR WERKS LGORT LGNUM MAKTX MATKL BISMT EXTWG BRGEW GEWEI GROES NORMT ZEINR ZEIVR AESZN ZEIFO EKGRP MFRPN MFRNR DISPO BKLAS VERPR PRCTR]
      
      ets.each do |et|
        puts et.isbn
        
        line << ["R#{et.isbn}",
                 "M001",
                 "S001",
                 "BLR",
                 sanitize_string(et.title).slice(0,40),
                 sap_matkl(et.language, et.category_id),
                 et.title_id,
                 et.pub_year,
                 et.weight_in_grams,
                 "G",
                 et.dimensions,
                 et.language,
                 sanitize_string(et.imprint.try(:publisher).try(:name)),
                 " ",
                 et.page_cnt,
                 "PB",
                 sap_ekgrp(et.language, et.category_id),
                 sanitize_string(et.author).slice(0,40),
                 " ",
                 "000",
                 "3000",
                 et.inr_price,
                 "SJB"                 
          ]
      end
    end
  end

  def self.fg(ets)
    CSV.generate(:col_sep => "\t") do |line|
      line << %w[MATNR MAKTX MATKL BISMT EXTWG BRGEW GEWEI GROES NORMT ZEINR ZEIVR AESZN ZEIFO EKGRP MFRPN MFRNR STPRS]
      
      ets.each do |et|
        puts et.isbn
        
        line << ["R#{et.isbn}",
                 sanitize_string(et.title).slice(0,40),
                 sap_matkl(et.language, et.category_id),
                 et.title_id,
                 et.pub_year,
                 et.weight_in_grams,
                 "G",
                 et.dimensions,
                 et.language,
                 sanitize_string(et.imprint.try(:publisher).try(:name)),
                 " ",
                 et.page_cnt,
                 "PB",
                 sap_ekgrp(et.language, et.category_id),
                 sanitize_string(et.author).slice(0,40),
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
    return "" if str.empty?
    str.gsub(/[\'|\,|\|\t"]/,"")
  end
end