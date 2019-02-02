# Validate Yum or Apt Repository
bareos_repo_path = if os.debian?
                     '/etc/apt/sources.list.d/bareos.list'
                   elsif os.redhat?
                     '/etc/yum.repos.d/bareos.repo'
                   end
bareos_contrib_repo_path = if os.debian?
                             '/etc/apt/sources.list.d/bareos_contrib.list'
                           elsif os.redhat?
                             '/etc/yum.repos.d/bareos_contrib.repo'
                           end

if os.family == 'debian'
  if os.name == 'debian'
    if os.release.to_i == 8
      describe file(bareos_repo_path) do
        it { should exist }
        its('content') { should match(%r{http://download.bareos.org/bareos/release/17.2/Debian_8.0/}) }
      end
      describe file(bareos_contrib_repo_path) do
        it { should exist }
        its('content') { should match(%r{http://download.bareos.org/bareos/contrib/Debian_8.0/}) }
      end
    elsif os.release.to_i == 9
      describe file(bareos_repo_path) do
        it { should exist }
        its('content') { should match(%r{http://download.bareos.org/bareos/release/17.2/Debian_9.0/}) }
      end
      describe file(bareos_contrib_repo_path) do
        it { should exist }
        its('content') { should match(%r{http://download.bareos.org/bareos/contrib/Debian_9.0/}) }
      end
    end
  elsif os.name == 'ubuntu'
    if os.release.to_i == 14
      describe file(bareos_repo_path) do
        it { should exist }
        its('content') { should match(%r{http://download.bareos.org/bareos/release/17.2/xUbuntu_14.04/}) }
      end
      describe file(bareos_contrib_repo_path) do
        it { should exist }
        its('content') { should match(%r{http://download.bareos.org/bareos/contrib/xUbuntu_14.04/}) }
      end
    elsif os.release.to_i == 16
      describe file(bareos_repo_path) do
        it { should exist }
        its('content') { should match(%r{http://download.bareos.org/bareos/release/17.2/xUbuntu_16.04/}) }
      end
      describe file(bareos_contrib_repo_path) do
        it { should_not exist }
      end
    elsif os.release.to_i == 18
      describe file(bareos_repo_path) do
        it { should exist }
        its('content') { should match(%r{http://download.bareos.org/bareos/release/17.2/xUbuntu_18.04/}) }
      end
      describe file(bareos_contrib_repo_path) do
        it { should_not exist }
      end
    end
  end
elsif os.family == 'redhat'
  if os.release.to_i == 6
    describe yum.repo('bareos') do
      it { should exist }
      it { should be_enabled }
    end
    describe yum.repo('bareos_contrib') do
      it { should exist }
      it { should be_enabled }
    end
  elsif os.release.to_i == 7
    describe yum.repo('bareos') do
      it { should exist }
      it { should be_enabled }
    end
    describe yum.repo('bareos_contrib') do
      it { should exist }
      it { should be_enabled }
    end
  end
end

describe package('bareos-common') do
  it { should be_installed }
end
