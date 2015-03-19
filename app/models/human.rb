require_relative '../../activerecord_lite/lib/db_objects'

class Human < SQLObject
  self.table_name = 'humans'

  self.finalize!
end
