module Masterman
  module Collection
    extend ActiveSupport::Concern

    included do
      include Enumerable

      class << self
        extend Forwardable

        delegate [:each] => :to_a

        delegate %i(
          delete_at select! delete_if compact! map! uniq! reverse! reject!
          flatten! sort! sort_by! collect! shuffle! keep_if rotate! slice
        ) => :spawn

        delegate %i(
          combination fill index rassoc reverse_each uniq
          any? compact find_index insert pack reject rindex shuffle take
          assoc first inspect permutation rotate take_while unshift
          at concat each flatten join pop repeated_combination size values_at
          bsearch count each_index sample to_ary zip
          clear cycle empty? frozen? last pretty_print_cycle replace select slice! to_h
          == collect delete eql? hash length product reverse sort to_s
          fetch include? map push transpose
        ) => :to_a
      end
    end

    class_methods do
      def find(id)
        load_records[id] || raise(RecordNotFound.new('missing record'))
      end

      def spawn
        to_a.dup
      end

      def to_records(records)
        records.each_with_object({}) do |attributes, memo|
          record = new(attributes)
          memo[record[primary_key]] = record
        end
      end
    end
  end
end
