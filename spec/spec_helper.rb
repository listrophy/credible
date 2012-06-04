# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require 'pathname'

module RSpec
  def self.root
    Pathname.new(File.expand_path('..', __FILE__))
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
