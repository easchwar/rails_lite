require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      #grab the belongs_to options for the Through class from self
      through_options = self.class.assoc_options[through_name]
      #grab the belongs_to options for the Source from the Through
      source_options = through_options.model_class.assoc_options[source_name]

      source_table = source_options.table_name
      through_table = through_options.table_name

      sql_str = <<-SQL
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table} ON #{through_table}.#{source_options.foreign_key} =
            #{source_table}.#{source_options.primary_key}
        WHERE
          #{through_table}.#{through_options.primary_key} = ?
        LIMIT 1
      SQL

      #returns hash options for source_options.model_class
      r = DBConnection.execute(sql_str, self.send(through_options.foreign_key))
      #instantiates the source's class using its parse_all class method
      source_options.model_class.parse_all(r).first
    end
  end
end
