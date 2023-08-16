# frozen_string_literal: true

class FastOpenStruct
  class Config
    attr_accessor :initialize_options, :attributes_options

    def initialize
      @initialize_options = { deep_initialize: true }
      @attributes_options = { symbolize_keys: false }
    end
  end
end
