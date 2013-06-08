require File.expand_path('../constants.rb', __FILE__)
Maid.rules do
  rule 'Notify myself of items to sort manually' do
    files = dir('~/Dropbox/_maid/_manual-sort/*')
    `echo #{files.inspect} | mail -s "Files to sort: #{files.length}" #{MY_EMAIL}`
  end

  # Desktop Screenshots
  rule 'Cleanup Misc Screenshots after 1 week' do
    dir('~/Desktop/Screen shot *').each do |path|
      if 1.week.since?(accessed_at(path))
        trash(path)
      end
    end
  end

end
