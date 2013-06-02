Maid.rules do
  emails = dir('~/Dropbox/_maid/mailto/*')
  rule 'Send Files in mailto folders' do
    for email in emails
      address = File.basename(email)

      dir("~/Dropbox/_maid/mailto/#{address}/*").each do |file|
        log(address)
        fn = File.basename(file)
        mod_time = modified_at(file)
        log("uuencode #{file} #{fn} | mail -s '#{fn}' #{address}")
        cmd("uuencode #{file} #{fn} | mail -s '#{fn}' #{address} && touch #{file}")
        new_mod_time = modified_at(file)
        unless mod_time == new_mod_time
          move(file, '~/Dropbox/_maid/processed')
        else
          puts mod_time.to_s
          puts new_mod_time.to_s
        end

      end
    end
  end
end
