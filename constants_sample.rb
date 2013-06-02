# Information I don't want to check into git

MY_EMAIL = "example@email.com"
PARSE_PDFs = [
  {:file_name => "daycare-invoice.pdf", 
   :content_match => /child care.*statement/, 
   :date_pre => '(date:? )',
   :date_format => "%m/%d/%Y",
   :move_path => '~/Dropbox/FileCabinet/Daycare'
  }
]
