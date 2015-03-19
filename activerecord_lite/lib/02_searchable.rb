require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |name| "#{name} = ?"}.join(' AND ')

    sql_str = <<-SQL
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL

    parse_all(DBConnection.execute(sql_str, *params.values))
  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end
