# frozen_string_literal: true

RSpec::Matchers.define :match_hash do |_ignored|
  match do |actual|
    @is_errors = []
    !match_hash(expected, actual)
  end

  # failure_message do |actual|
  #   differ = RSpec::Expectations.differ
  #   failure_message = RSpec::Matchers::ExpectedsForMultipleDiffs
  #                      .from(expected)
  #                      .message_with_diff(nil, differ, actual)
  #   failure_message
  # end
end
