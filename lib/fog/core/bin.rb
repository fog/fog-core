module Fog
  class << self
    def available_providers
      @available_providers ||= begin
        Fog.providers.values.select do |provider|
          p = const_get(provider)
          defined?(p) && p.respond_to?(:available?) && p.available?
        end.sort
      end
    end

    def registered_providers
      @registered_providers ||= Fog.providers.values.sort
    end
  end

  class Bin
    class << self
      def available?
        availability = true
        for service in services
          begin
            service = self.class_for(service)
            availability &&= service.requirements.all? { |requirement| Fog.credentials.include?(requirement) }
          rescue ArgumentError => e
            Fog::Logger.warning(e.message)
            availability = false
          rescue => e
            availability = false
          end
        end

        if availability
          for service in services
            for collection in self.class_for(service).collections
              unless self.respond_to?(collection)
                self.class_eval <<-EOS, __FILE__, __LINE__
                  def self.#{collection}
                    self[:#{service}].#{collection}
                  end
                EOS
              end
            end
          end
        end

        availability
      end

      def collections
        services.map {|service| self[service].collections}.flatten.sort_by {|service| service.to_s}
      end
    end
  end
end

require 'fog/core/bin/aws'
require 'fog/core/bin/bare_metal_cloud'
require 'fog/core/bin/bluebox'
require 'fog/core/bin/brightbox'
require 'fog/core/bin/clodo'
require 'fog/core/bin/cloudsigma'
require 'fog/core/bin/cloudstack'
require 'fog/core/bin/digitalocean'
require 'fog/core/bin/dnsimple'
require 'fog/core/bin/dnsmadeeasy'
require 'fog/core/bin/dreamhost'
require 'fog/core/bin/dynect'
require 'fog/core/bin/fogdocker'
require 'fog/core/bin/glesys'
require 'fog/core/bin/go_grid'
require 'fog/core/bin/google'
require 'fog/core/bin/hp'
require 'fog/core/bin/ibm'
require 'fog/core/bin/internet_archive'
require 'fog/core/bin/joyent'
require 'fog/core/bin/libvirt'
require 'fog/core/bin/linode'
require 'fog/core/bin/local'
require 'fog/core/bin/ninefold'
require 'fog/core/bin/opennebula'
require 'fog/core/bin/openstack'
require 'fog/core/bin/openvz'
require 'fog/core/bin/ovirt'
require 'fog/core/bin/rage4'
require 'fog/core/bin/riakcs'
require 'fog/core/bin/serverlove'
require 'fog/core/bin/softlayer'
require 'fog/core/bin/vcloud'
require 'fog/core/bin/vcloud_director'
require 'fog/core/bin/vsphere'
require 'fog/core/bin/xenserver'
require 'fog/core/bin/zerigo'
