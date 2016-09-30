RSpec::Matchers.define :permitted_to do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for #{policy.user.inspect}."
  end
end

def pundit_error
  Pundit::NotAuthorizedError
end

=begin

example: spec/policies/projects_policy_spec.rb

require 'rails_helper'

describe ProjectPolicy do
  subject { ProjectPolicy.new(user, project) }
  let(:project) { Fabricate :project }


  context 'for a visitor' do
    it { should_not permitted_to(:create)  }
    it { should_not permitted_to(:new)     }
    it { should_not permitted_to(:update)  }
    it { should_not permitted_to(:edit)    }
  end

  context "for an admin" do
    let(:user) { Fabricate(:user, admin: true) }

    it { should permitted_to(:create)  }
    it { should permitted_to(:new)     }
    it { should permitted_to(:update)  }
    it { should permitted_to(:edit)    }
  end
end

=end
