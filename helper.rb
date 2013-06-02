require 'date'

def find_mdy_slash_date(text, date_pre)
  #date_only = /(\w*)\.?\s(\d?\s?\d)\s?\,\s(\d?\s?\d?\s?\d\s?\d)/
  date_only = /(\d?\d)\/\s?(\d?\d)\/\s?(\d?\d?\d\d)/
  date_regex = /#{date_pre}#{date_only}/
  text_date = text.match(date_regex)
  unless text_date.nil?
    yr = (text_date[3].length == 4 ? text_date[3] : "20#{text_date[3]}")
    #yr = text_date[3]
    mo = "%02d" % text_date[1].to_i
    day = "%02d" % text_date[2].to_i
    return "#{yr}-#{mo}-#{day}"
  else
    log(text)
    return "nil"
  end
end

def find_date(text, date_pre, date_format)
  date_only = ""
  case date_format
  when "%m/%d/%Y" "%m/%d/%y"
    date_only = '(\d?\d\/\s?\d?\d\/\s?\d?\d?\d\d)'
  end
  date_regex = /#{date_pre}#{date_only}/
  text_date = text.match(date_regex)
  unless text_date[2].nil?
    real_date = Date.strptime(text_date[2], date_format)
    return real_date.strftime("%F")
  else
    log(text)
    return "nil"
  end
end

def rename_with_date(file, file_date, file_new_name)
  file_ext = File.extname(file)
  this_path = File.dirname(file)
  if file_date.length == 10
    rename(file, "#{this_path}/#{file_date}-#{file_new_name}#{file_ext}")
    return "#{this_path}/#{file_date}-#{file_new_name}#{file_ext}"
  else
    log("#{file} has a bad date - #{file_date}")
    return false
  end
end

def move_to_filecabinet(file, folder, month)
  if file 
    year = File.basename(file)[0..3]
    new_path = "~/Dropbox/FileCabinet/#{folder}/#{year}"
    if month == true
      mo = File.basename(file)[5..6]
      new_path = "~/Dropbox/FileCabinet/#{folder}/#{year}/#{mo}"
    end
    mkdir(new_path)
    move(file, new_path)
  end
end
