require_relative '../lib/reek/smells/smell_repository'
require 'yaml'

namespace :configuration do
  task :update_default_configuration do
    DEFAULT_SMELL_CONFIGURATION = 'config/defaults.reek'
    content = Reek::Smells::SmellRepository.smell_types.each_with_object({}) do |klass, hash|
      hash[klass.smell_type] = klass.default_config
    end
    File.open(DEFAULT_SMELL_CONFIGURATION, 'w') { |file| YAML.dump(content, file) }
  end
end

task 'test:spec' => 'configuration:update_default_configuration'
