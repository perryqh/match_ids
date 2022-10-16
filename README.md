# MatchIds

Scenario: you are deprecating API response IDs in favor of UUIDs and you want to verify
that IDs are no longer contained in the responses.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add match_ids

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install match_ids

## Usage

`match_ids` provides an RSpec matcher `have_id_keys` with an
optional `ignored` list.

```ruby
context "a payload with ids" do
  let(:payload) do
    { id: 3,
      name: "Test",
      location_id: 44,
      foo: { id: 8 } }
  end

  it "contains IDs" do
    expect(payload).to have_id_keys
  end

  it "contains no unexpected IDs" do
    expect(payload)
      .not_to have_id_keys(ignored: [{ id: { ancestors: [] } },
                                     { location_id: { ancestors: [] } },
                                     { id: { ancestors: [:foo] } }])
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/match_ids.
