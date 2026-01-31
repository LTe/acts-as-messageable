# RBI generation framework

`RBI` provides a Ruby API to compose Ruby interface files consumed by Sorbet.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbi'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rbi

## Usage

```rb
require "rbi"

rbi = RBI::File.new(strictness: "true") do |file|
  file << RBI::Module.new("Foo") do |mod|
    mod << RBI::Method.new("foo")
  end
end

puts rbi.string
```

will produce:

```rb
# typed: true

module Foo
  def foo; end
end
```

## Features

* RBI generation API
* RBI parsing with Whitequark
* RBI formatting
* RBI validation
* RBI merging

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

This repo uses itself (`rbi`) to retrieve and generate gem RBIs. You can run `dev rbi` to update local gem RBIs with RBIs from the central repo.

## Releasing

### Bump the gem version

- [ ] Locally, update the version number in [`version.rb`](https://github.com/Shopify/spoom/blob/main/lib/rbi/version.rb)
- [ ] Run `bundle install` to update the version number in `Gemfile.lock`
- [ ] Commit this change with the message `Bump version to vx.y.z`
- [ ] Push this change directly to main or open a PR

### Create a new tag

- [ ] Locally, create a new tag with the new version number: `git tag vx.y.z`
- [ ] Push this tag up to the remote `git push origin vx.y.z`

### Release workflow will run automatically

We have a [release workflow](https://github.com/Shopify/rbi/actions/workflows/release.yml) that will publish your new gem version to rubygems.org via [Trusted Publishing](https://guides.rubygems.org/trusted-publishing/). This workflow must be approved by a member of the Ruby and Rails Infrastructure team at Shopify before it will run. Once it is approved, it will automatically publish a new gem version to rubygems.org and create a new GitHub release.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Shopify/rbi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Shopify/rbi/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rbi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rbi/blob/master/CODE_OF_CONDUCT.md).
