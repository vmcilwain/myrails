# Myrails

This gem was created to make generating rails related files and other rails gem files (that I use) a lot easier. It is a thor backed gem that was designed with rails 5 in mind but most of it "should" work with rails 4.

This gem is not endorsed by the rails core team. I wrote it as a convenience for generating files that I would otherwise have written by hand.

## Disclaimer

`user at your own risk!` I am not held responsible for using this gem. If you are not usre it will work for you, install it on a vagrant vm and give it a try there. You can use even use the Vagrantfile that is in this repo to take care of configuring a useable vm.

This gem is not compatible with ruby 2.3 (yet).

## Notes

Use 1.1.1 if you are primarily developing in rails 3 & 4

Use the latest version if are primarily developing in rails 5

## Examples

Here is an example of the gem works:

Lets say I use pundit. With this gem I am able to run the following:

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

Inside app/policies/articles_policy.rb is boiler plate code like:

```
class ArticlePolicy < ApplicationPolicy
  # Allow all users to access new article
  def new?
    true
  end

  # Allows owner to edit Article
  def edit?
    user == record.user
  end

  # Allows all users to create Article
  alias_method :create?, :new?

  # Allows all users to view Article
  alias_method :show?, :new?

  # Allows owner to update an Article
  alias_method :update?, :edit?

  # Allows owner to remove an Article
  alias_method :destroy?, :edit?
end
```

Inside the spec/policies/articles_policy_spec.rb is boiler plate code like:

```
# Use with Pundit Matches: https://github.com/chrisalley/pundit-matchers
require 'rails_helper'
describe ArticlePolicy do
  subject { ArticlePolicy.new(user, article) }

  let(:article) { create :article }

  context 'for a visitor' do
    it {is_expected.to permit_action(:new)}
    it {is_expected.to permit_action(:create)}
    it {is_expected.to permit_action(:show)}
    it {is_expected.to forbid_action(:edit)}
    it {is_expected.to forbid_action(:update)}
    it {is_expected.to forbid_action(:destroy)}
  end

  context "for an admin" do

    let(:user) { article.user }

    it {is_expected.to permit_action(:new)}
    it {is_expected.to permit_action(:create)}
    it {is_expected.to permit_action(:show)}
    it {is_expected.to permit_action(:edit)}
    it {is_expected.to permit_action(:update)}
    it {is_expected.to permit_action(:destroy)}
  end
end
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

Simply type `myrails` to see the help menu

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
