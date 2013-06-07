require File.expand_path('../constants.rb', __FILE__)
Maid.rules do
  rule 'Notify myself of items to sort manually' do
    files = dir('~/Dropbox/_maid/_manual-sort/*')
    `echo #{files.inspect} | mail -s "Files to sort: #{files.length}" #{MY_EMAIL}`
  end

  rule 'Send Files in mailto folders' do
    emails = dir('~/Dropbox/_maid/mailto/*')
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
        end
      end
    end
  end

end
