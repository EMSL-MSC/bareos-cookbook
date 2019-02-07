module BareosCookbook
  module Helper
    def bareos_resource?(name)
      resources name
      true
    rescue Chef::Exceptions::ResourceNotFound
      false
    end
  end
end
