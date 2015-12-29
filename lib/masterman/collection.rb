module Masterman
  module Collection
    extend ActiveSupport::Concern

    included do
      include Enumerable

      class << self
        extend Forwardable

        delegate %i(each) => :to_a

        delegate %i(
          delete_at select! delete_if compact! map! uniq! reverse! reject!
          flatten! sort! sort_by! collect! shuffle! keep_if rotate! slice!
        ) => :spawn

        delegate %i(
          combination fill index rassoc reverse_each uniq
          any? compact find_index insert pack reject rindex shuffle take
          assoc first permutation rotate take_while unshift
          at concat each flatten join pop repeated_combination size values_at
          bsearch count each_index sample to_ary zip
          clear cycle empty? frozen? last pretty_print_cycle replace select to_h slice
          == collect delete eql? hash length product reverse sort
          fetch include? map push transpose
        ) => :to_a
      end
    end

    module ClassMethods
      def all
        to_a
      end

      def find(id)
        masterman.all[id] || raise(RecordNotFound.new('missing record'))
      end

      def find_by(attributes)
        masterman.all.values.find do |record|
          attributes.all? do |key, value|
            record[key] == value
          end
        end
      end

      def spawn
        to_a.dup
      end

      def to_a
        masterman.all.values
      end
    end
  end
end
