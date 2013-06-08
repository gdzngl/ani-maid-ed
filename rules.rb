require File.expand_path('../constants.rb', __FILE__)
require File.expand_path('../helper.rb', __FILE__)
# Test using:
#
#     maid clean -n
#
# If you come up with some cool tools of your own, please send me a pull request on GitHub!  Also, please consider sharing your rules with others via [the wiki](https://github.com/benjaminoakes/maid/wiki).

Maid.rules do
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

  # Used the touch command here to make sure the command completed successfully
  # Feels like there should be a better way
  rule "Email files to myself" do
    dir('~/Dropbox/_maid/mailto-me/*').each do |file|
      fn = File.basename(file)
      mod_time = modified_at(file)
      log("uuencode #{file} #{fn} | mail -s '#{fn}' #{MY_EMAIL}")
      cmd("uuencode #{file} #{fn} | mail -s '#{fn}' #{MY_EMAIL} && touch #{file}")
      new_mod_time = modified_at(file)
      unless mod_time == new_mod_time
        move(file, '~/Dropbox/_maid/processed')
    end
  end
end
