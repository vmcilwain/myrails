# Myrails

This gem was created to make generating rails related files and other rails gem files (that I use) a lot easier. It is a thor backed gem that was designed with rails 5 in mind but most of it "should" work with rails 4.

This gem is not endorsed by 37signals. I wrote it as a convenience for generating files that I would otherwise have written by hand.

## Disclaimer

`user at your own risk!`

This gem is not compatible with ruby 2.3 (yet).

## Notes

Use 1.1.1 if you are primarily developing in rails 3 & 4

Use 2.x.x if are primarily developing in rails 5

## Examples

Here is an example of the gem in action:

For example, I use pundit. With this gem I am able to run the following:

```ruby
myrails policy --name=article
```

which outputs:

```
create  app/policies/article_policy.rb
create  spec/policies/article_policy_spec.rb
```

with corresponding files:

```
.
├── app
│   └── policies
│       └── article_policy.rb

└── spec
    └── policies
        └── article_policy_spec.rb
```


## Installation

In your terminal:

```ruby
# For development in rails 3 & 4 primarily

gem install myrails -v 1.1.1

# For development in rails 5 primarily

gem install myrails
```

## Usage

simple type `myrails` to see the help menu

```ruby
# Example for generating a presenter class
myrails presenter --name=post
```
This generates a PostPresenter class in app/presenters that inherits from app/presenters/base_presenter.rb to be used in views. This also generates a spec/presenters/post_presenter_spec.rb file for testing.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Releasing
To release a new version,
* update the version number in `version.rb`
* tag the the code `git tag v1.0.0`
* push the tag `git push --tags`
* then run `bundle exec rake build`
* `gem push pkg/myrails-version`

Which will push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vmcilwain/myrails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
