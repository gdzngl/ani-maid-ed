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

  # Move pdf files that already have text to folder where I check to make sure they are complete
  rule 'Move pdf files that are already OCRed' do
    dir('~/Dropbox/_maid/ocr-pdf/*.pdf').each do |pdf_file|
      pdf_text = cmd("/usr/bin/mdimport -d2 \"#{pdf_file}\" 2>&1")
      if pdf_text.include?("kMDItemTextContent")
        move(pdf_file, '~/Dropbox/_maid/_manual-sort')
      end
    end
  end
end
