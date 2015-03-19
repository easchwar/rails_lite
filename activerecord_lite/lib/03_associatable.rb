require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @class_name = options[:class_name] || name.to_s.camelcase
    @foreign_key = options[:foreign_key] || name.to_s.concat('_id').to_sym
    @primary_key = options[:primary_key] || 'id'.to_sym
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @class_name = options[:class_name] || name.to_s.singularize.camelcase
    @foreign_key = options[:foreign_key] ||
      self_class_name.underscore.concat('_id').to_sym
    @primary_key = options[:primary_key] || 'id'.to_sym
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      pk = options.primary_key
      fk = self.send(options.foreign_key)
      options.model_class.where("#{options.table_name}.#{pk}" => fk).first
    end

    self.assoc_options[name] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      pk = self.send(options.primary_key)
      fk = options.foreign_key
      options.model_class.where("#{options.table_name}.#{fk}" => pk)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
