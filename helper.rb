require 'date'
require 'pp'

def find_date(text, date_pre, date_format)
  log("-----Date Prefix: #{date_pre.source}")
  log("-----Date Format: #{date_format}")
  date_only = ""
  case date_format
  when "%m/%d/%Y", "%m/%d/%y"
    date_only = /(\d?\d)\/\s?(\d?\d)\/\s?(\d?\d?\d\d)/
  when "%b. %d, %Y"
    date_only = /([a-z][a-z][a-z])\.?\s(\d?\d)\,\s(\d\d\d\d)/
  when "%B %d, %Y"
    date_only = /(\w*)\s(\d?\d)\,\s(\d\d\d\d)/
  when "%m-%d-%y"
    date_only = /(\d?\d)\-(\d?\d)\-(\d?\d?\d\d)/
  end
  date_regex = /#{date_pre.source}#{date_only.source}/
  log("-----Date Regex: #{date_regex.source}")
  text_date = text.match(date_regex)
  text_date ||= [nil, nil, nil]
  log("-----Date Match: #{text_date.inspect}")
  case date_format
  when "%m/%d/%Y", "%m/%d/%y"
    this_date = "#{text_date[2]}/#{text_date[3]}/#{text_date[4]}"  
  when "%b. %d, %Y"
    this_date = "#{text_date[2]}. #{text_date[3]}, #{text_date[4]}"  
  when "%B %d, %Y"
    this_date = "#{text_date[2]} #{text_date[3]}, #{text_date[4]}"  
  when "%m-%d-%y"
    this_date = "#{text_date[2]}-#{text_date[3]}-#{text_date[4]}"  
  end
  unless text_date[2].nil?
    real_date = Date.strptime(this_date, date_format)
    return real_date.strftime("%F")
  else
    log("----Parsed date is nil")
    log(text)
    return "nil"
  end
end

def get_pdf_text(pdf_file)
  orig_pdf_text = cmd("/usr/bin/mdimport -d2 \"#{pdf_file}\" 2>&1").downcase
  array_pdf_text = orig_pdf_text.split("\n")
  array_pdf_text.delete_if {|v| !v.include?("kmditemtextcontent") && !v.include?("kmditemfindercomment")}
  #pp array_pdf_text
  pdf_text = array_pdf_text.to_s.gsub("\\u2022", "-")
  #pp pdf_text
  return pdf_text
end
