Maid.rules do
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
end
