module Masterman
  module Mountable
    attr_writer :primary_key

    def mount(options = {})
      @loader = Loader.build(options)
    end

    def primary_key
      @primary_key || :id
    end

    def loader
      @loader || MastermanError.new('not mounted or bad option given')
    end
  end
end
