module Fog
  module ServicesMixin
    def [](provider)
      new(:provider => provider)
    end
  end
end
