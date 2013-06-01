require_relative 'constants.rb'
Maid.rules do
  rule 'Notify myself of items to sort manually' do
    files = dir('~/Dropbox/_maid/_manual-sort/*')
    `echo #{files.inspect} | mail -s "Files to sort: #{files.length}" #{MY_EMAIL}`
  end
end
