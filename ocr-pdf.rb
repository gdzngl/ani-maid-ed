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
end
