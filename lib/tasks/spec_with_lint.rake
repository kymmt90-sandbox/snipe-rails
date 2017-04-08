desc 'Run all specs in spec directory with factory linting (excluding plugin specs)'
task spec_with_lint: :environment do
  if Rails.env.test?
    begin
      FactoryGirl.lint trait: true
    ensure
      DatabaseRewinder.clean_all
    end
    Rake::Task[:spec].invoke
  else
    system "bundle exec rake spec_with_lint RAILS_ENV='test'"
  end
end
