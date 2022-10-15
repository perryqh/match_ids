# frozen_string_literal: true

RSpec::Matchers.define :have_id_keys do |ignored|
  def actual_ignored(ignored)
    if ignored.nil? || !ignored.is_a?(Hash)
      []
    else
      ignored[:ignored]
    end
  end

  match do |actual|
    MatchIds::IdFinder
      .new(actual, ignored: actual_ignored(ignored))
      .id_keys.length.positive?
  end

  failure_message_when_negated do |actual|
    parsed_ignored = actual_ignored(ignored)
    MatchIds::IdFinder
      .new(actual, ignored: parsed_ignored)
      .ids_found_error_message
  end
end
