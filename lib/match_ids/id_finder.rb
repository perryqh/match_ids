# frozen_string_literal: true

module MatchIds
  class IdFinder
    attr_reader :payload, :ignored

    def initialize(payload, ignored: [])
      @payload = payload.nil? ? [] : payload
      @ignored = ignored.nil? ? [] : ignored
    end

    def nested_keys
      @nested_keys ||= keys_with_ancestors
    end

    def error_message
      return unless id_keys.length.positive?

      "Expected not to find the following ID keys: #{id_keys}"
    end

    def id_keys
      @id_keys ||= nested_keys.select { |k| id_key?(k) }
    end

    private

    def keys_with_ancestors
      @keys_with_ancestors ||= keys_only(payload)
                               .flatten.map do |hash|
        { hash.keys.first => { ancestors: hash.values.first } }
      end
    end

    def keys_only(hash, path: [])
      hash.map do |key, value|
        value = value.first if value.is_a?(Array)

        if value.is_a?(Hash)
          [{ key => path }, [keys_only(value, path: path + [key])]]
        else
          { key => path }
        end
      end
    end

    def id_key?(key_val)
      return false if [ignored].flatten.include?(key_val)

      key = key_val.keys.first
      key.to_s.end_with?("_id", "_ids") || key.to_s == "id"
    end
  end
end
