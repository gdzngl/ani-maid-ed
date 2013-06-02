require 'date'
require 'pp'

def find_date(text, date_pre, date_format)
  log("-----Date Prefix: #{date_pre}")
  log("-----Date Format: #{date_format}")
  date_only = ""
  case date_format
  when "%m/%d/%Y", "%m/%d/%y"
    date_only = '(\d?\d\/\s?\d?\d\/\s?\d?\d?\d\d)'
  end
  date_regex = /#{date_pre}#{date_only}/
  log("-----Date Regex: #{date_regex}")
  text_date = text.match(date_regex)
  log("-----Date Match: #{text_date.inspect}")
  unless text_date[2].nil?
    real_date = Date.strptime(text_date[2], date_format)
    return real_date.strftime("%F")
  else
    log(text)
    return "nil"
  end
end

def get_pdf_text(pdf_file)
  orig_pdf_text = cmd("/usr/bin/mdimport -d2 \"#{pdf_file}\" 2>&1").downcase
  array_pdf_text = orig_pdf_text.split("\n")
  array_pdf_text.delete_if {|v| v[4..21] != "kmditemtextcontent"}
  return array_pdf_text[0]
end
