module Masterman
  module Collection
    extend Forwardable

    delegate %i(all find take take! first first! last last! exists? any? many?) => :relation
    delegate %i(find_by find_by!) => :relation
    delegate %i(pluck ids) => :relation

    def relation
      records = masterman.loader.all
      Masterman::Relation.new(masterman.model_class, records)
    end
  end
end
