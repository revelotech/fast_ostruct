# frozen_string_literal: true

require 'json'
require 'set'
require_relative 'fast_ostruct/config'
require_relative 'fast_ostruct/version'

class FastOpenStruct
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end
  end

  def config
    self.class.config
  end

  def initialize(attributes = {}, options = config.initialize_options)
    if options[:deep_initialize]
      attributes.except(*options.keys).each_pair do |name, value|
        self[name] = deep_initialize(value, options)
      end
    else
      attributes.except(*options.keys).each_pair do |name, value|
        self[name] = value
      end
    end
  end

  def attributes(options = config.attributes_options)
    key_formatter = if options[:symbolize_keys]
                      proc { |name| name.to_sym }
                    else
                      proc { |name| name.to_s }
                    end

    instance_variables.each_with_object({}) do |var, hash|
      name = var.to_s.delete('@')
      value = attribute_get(name)
      hash[key_formatter.call(name)] = value.is_a?(FastOpenStruct) ? value.attributes(options) : value
    end
  end

  # Serializable
  def as_json(*_args)
    attributes
  end

  def to_json(*_args)
    JSON.generate(attributes)
  end
  alias serializable_hash attributes
  alias to_h attributes

  # Hasheable
  def [](name)
    attribute_get(name)
  end

  def []=(name, value)
    attribute_set(name, value)
  end

  def dig(name, *identifiers)
    name = name.to_sym
    identifiers.map!(&:to_sym) if identifiers.any?
    attributes(symbolize_keys: true).dig(name, *identifiers)
  end

  def slice(*names)
    names.map!(&:to_sym)
    attributes(symbolize_keys: true).slice(*names)
  end

  def delete_field(name)
    attribute_unset(name)
  end

  # Comparable
  def ==(other)
    other.is_a?(self.class) && attributes == other.attributes
  end

  def eql?(other)
    other.is_a?(self.class) && attributes.eql?(other.attributes)
  end

  # Persistent
  def persisted?
    false
  end

  def save(*)
    self
  end

  def new_record?
    true
  end

  alias save! save
  alias create save
  alias create! save
  alias update save
  alias update! save
  alias delete save
  alias destroy save
  alias destroy! save
  alias reload save

  private

  class << self
    def defined_methods
      @defined_methods ||= Set.new
    end

    def define_methods!(name)
      class_exec do
        attr_accessor name

        defined_methods << name
      end
    end
  end

  def deep_initialize(value, options = config.initialize_options)
    if value.is_a?(Array)
      value = value.map { |v| v.is_a?(Hash) ? self.class.new(v, options) : v }
    elsif value.is_a?(Hash)
      value = self.class.new(value, options)
    end
    value
  end

  def attribute_set(name, value = nil)
    return if name.nil?

    name = name.to_sym
    self.class.define_methods!(name) unless self.class.defined_methods.include?(name)
    instance_variable_set(:"@#{name}", value)
  end

  def attribute_get(name)
    instance_variable_get(:"@#{name}")
  end

  def attribute_unset(name)
    remove_instance_variable(:"@#{name}")
  end

  def method_missing(mid, *args)
    if (mname = mid[/.*(?==\z)/m])
      self[mname] = args.first
    else
      self[mid]
    end
  end

  def respond_to_missing?(*args)
    super(*args)
  end
end
