# MyRails

A library for generating rails related templates and configuring some standard gems (that I use) a lot easier. This was designed with Rails 5 in mind but most of it "should" work with rails 4. An example of the design differences is, a generated model inherit from `ApplicatinoRecord` instead of `ActiveRecord::Base`

This library is not endorsed by the Rails core team. I wrote it as a convenience for generating code that I would otherwise have written by hand or would have had to manage with code snippets (I use more than one editor)

## Disclaimer

`Use at your own risk!` I am not responsible for any issues that come from using this library. If you are not sure it will work for you, install it on a vagrant vm and give it a try there. You can even use the Vagrantfile that is in this repo to take care of configuring a useable vm.

This does not work with the windows environment

## Notes

Use v1.1.1 if you are primarily developing in rails 3 & 4

Use the latest version if you are primarily developing in rails 5

## Requirements

Ruby 2.2 and above

## Examples

A gem I use often is pundit. With this library I can generate a policy along with an RSpec pundit matcher file to test the policy with. I am able to run the following:

```ruby
myrails kickstart policy article
```

which outputs something like:

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

Inside app/policies/articles_policy.rb is boiler plate code (something like):

```ruby
class ArticlePolicy < ApplicationPolicy

  def new?
    true
  end

  def edit?
    user == record.user
  end

  alias_method :create?, :new?

  alias_method :show?, :new?

  alias_method :update?, :edit?

  alias_method :destroy?, :edit?
end
```

Inside the spec/policies/articles_policy_spec.rb is boiler plate code (something like):

```ruby
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

In the terminal:

### For use with Rails 3 & 4

```ruby
gem install myrails -v 1.1.1
```

### For use with Rails 5

```ruby
gem install myrails
```

## Usage

Simply type `myrails` to see the help menu

The current options available are:

* db - Rails database options
* engine (aliase e) - Rails engine options
* install (aliase i) - Rails gems and configuration options
* kickstart (aliase ks) - Rails template generation options
* spec (aliase s) - RSpec template generation options
* setup_sendgrid - Install sendgrid initializer with mail interceptor

Every option also has a help menu. For instance, specifying `myrails kickstart` will display something like:

```
ERROR: "myrails kickstart" was called with no arguments
Usage: "myrails kickstart <OPTION> <NAME>"
Available Options:
* controller: Generate rails controller with corresponding RSpec file
* decorator: Generate draper decorator with corresponding RSpec file
* factory: Generate factory[girl|bot] factory
* model: Generate rails model with corresponding RSpec file
* policy: Generate pundit policy with corresponding RSpec file
* ui: Generate a ui file for mocking front end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake build` then `bundle exec rake install`.

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
