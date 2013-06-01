require File.expand_path('../constants.rb', __FILE__)
require File.expand_path('../helper.rb', __FILE__)
# Test using:
#
#     maid clean -n
#
# If you come up with some cool tools of your own, please send me a pull request on GitHub!  Also, please consider sharing your rules with others via [the wiki](https://github.com/benjaminoakes/maid/wiki).

Maid.rules do
  # Desktop Screenshots
  rule 'Cleanup Misc Screenshots after 1 week' do
    dir('~/Desktop/Screen shot *').each do |path|
      if 1.week.since?(accessed_at(path))
        trash(path)
      end
    end
  end

  # Files that have been processed and converted to something else
  # JPGs converted to pdfs
  # PDFs that have been combined with others
  rule 'Cleanup Processed Files after 1 week' do 
    dir('~/Dropbox/_maid/processed/*').each do |path|
      if 1.week.since?(accessed_at(path))
        trash(path)
      end
    end
  end

  # OCR files with Applescript that calls PDFPen
  # Only works on OSX
  rule 'OCR pdf files' do
    dir('~/Dropbox/_maid/ocr-pdf/*.pdf').each do |pdf_file|
      pdf_text = cmd("/usr/bin/mdimport -d2 \"#{pdf_file}\" 2>&1")
      unless pdf_text.include?("kMDItemTextContent")
        log("osascript ~/.maid/scripts/ocr-with-pdfpen.scpt \"#{pdf_file}\"")
        cmd("osascript ~/.maid/scripts/ocr-with-pdfpen.scpt \"#{pdf_file}\"")
      end
    end
  end

  # Move pdf files that already have text to folder where I check them
  rule 'Move pdf files that are already OCRed' do
    dir('~/Dropbox/_maid/ocr-pdf/*.pdf').each do |pdf_file|
      pdf_text = cmd("/usr/bin/mdimport -d2 \"#{pdf_file}\" 2>&1")
      if pdf_text.include?("kMDItemTextContent")
        move(pdf_file, '~/Dropbox/_maid/_manual-sort')
      end
    end
  end

  # Rename file based on date in content
  # I have more of these in a separate rules file
  # Since most of them will have account numbers I'm not checking them in.
  rule "Rename pdf files based on contents" do
    dir('~/Dropbox/_maid/rename-content/*.pdf').each do |pdf_file|
      pdf_text = cmd("/usr/bin/mdimport -d2 \"#{pdf_file}\" 2>&1")

      # Daycare statements
      if pdf_text.include?(DAYCARE) && pdf_text.include?("Statement")
        file_date = find_mdy_slash_date(pdf_text, "From:? ")
        new_name = rename_with_date(pdf_file, file_date, DC_FN)
        move_to_filecabinet(new_name, DC_FOLDER, false)
      end
    end
  end

  rule "Email files to myself" do
    dir('~/Dropbox/_maid/mailto-me/*').each do |file|
      fn = File.basename(file)
      log("uuencode #{file} #{fn} | mail -s '#{fn}' #{MY_EMAIL}")
    end
  end

end
