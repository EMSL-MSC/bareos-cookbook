source 'https://supermarket.chef.io'

metadata

solver :ruby, :required

group :integration do
  Dir['test/fixtures/cookbooks/**/metadata.rb'].each do |metadata|
    cookbook File.basename(File.dirname(metadata)), path: File.dirname(metadata)
  end
end
