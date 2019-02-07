# Validate the console resources and test recipes
cons_path = '/etc/bareos'

describe package('bareos-bconsole') do
  it { should be_installed }
end

describe directory(cons_path) do
  it { should exist }
end
