require File.expand_path('../constants.rb', __FILE__)
require File.expand_path('../helper.rb', __FILE__)

Maid.rules do
  rule "Rename pdf files based on contents" do
    dir('~/Dropbox/_maid/rename/content/*.pdf').each do |pdf_file|
      pdf_text = cmd("/usr/bin/mdimport -d2 \"#{pdf_file}\" 2>&1").downcase
      this_path = File.dirname(pdf_file)
      this_file_name = File.basename(pdf_file)
      log("-----#{this_file_name}-----")

      matched = false
      for item in PARSE_PDFs
        if pdf_text.match(item[:content_match])
          log("#{this_file_name} matched #{item[:file_name]}")
          unless pdf_file.include?(item[:file_name])
            rename(pdf_file, "#{this_path}/#{item[:file_name]}")
            matched = true
          else
            file_date = find_date(pdf_text, item[:date_pre], item[:date_format])
            unless pdf_file.include?(file_date)
              if file_date.match(/\d\d\d\d-\d\d-\d\d/)
                rename(pdf_file, "#{this_path}/#{file_date}-#{this_file_name}")
              else
                log("#{pdf_file} has a bad date - #{file_date}")
              end
              matched = true
            else
              yr = this_file_name[0..3]
              if yr.match(/\d\d\d\d/)
                rename(pdf_file, "#{item[:move_path]}/#{yr}/#{this_file_name}")
                matched = true
              else
                log("Error with #{pdf_file} file name.")
                matched = true
              end
            end
          end
        end
        unless matched
          log(pdf_text)
        end
      end

    end
  end

end
