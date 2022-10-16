# frozen_string_literal: true

module MatchIds
  # Finds ID keys in payload ignoring IDs provided `ignored` param
  class IdFinder
    attr_reader :payload, :ignored, :payload_is_array

    ROOT_WHEN_ARRAY = :root

    def initialize(payload, ignored: [])
      @payload = normalized_payload(payload)
      @ignored = ignored.nil? ? [] : ignored
    end

    def nested_keys
      @nested_keys ||= keys_only(payload)
                       .flatten.map do |hash|
        { hash.keys.first => { ancestors: hash.values.first } }
      end
    end

    def ids_found_error_message
      return unless id_keys.length.positive?

      msg = "Expected #{payload}"
      msg += " with ignored #{ignored}" if ignored.length.positive?
      "#{msg} to not have ID keys: #{id_keys}"
    end

    def id_keys
      @id_keys ||= nested_keys.select { |k| id_key?(k) }
    end

    private

    def normalized_payload(payload)
      return {} if payload.nil?

      if payload.is_a?(Array)
        @payload_is_array = true
        { ROOT_WHEN_ARRAY => payload }
      else
        payload
      end
    end

    def keys_only(hash, path: [])
      hash.map do |key, value|
        value = value.first if value.is_a?(Array)

        if value.is_a?(Hash)
          new_path = append_path_name(key, path)
          [{ key => path }, [keys_only(value, path: new_path)]]
        else
          { key => path }
        end
      end
    end

    def append_path_name(key, path)
      if key == ROOT_WHEN_ARRAY && path.empty? && payload_is_array
        path
      else
        path + [key]
      end
    end

    def id_key?(key_val)
      return false if [ignored].flatten.include?(key_val)

      key = key_val.keys.first
      key.to_s.end_with?("_id", "_ids") || key.to_s == "id"
    end
  end
end
