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
end
