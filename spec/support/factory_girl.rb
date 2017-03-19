RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    ActiveRecord::Base.transaction do
      FactoryGirl.lint(traits: true)
      raise ActiveRecord::Rollback # Revert the records create by FactoryGirl.lint
    end
  end
end
