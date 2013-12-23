group :tests do
  # Run code quality checks against all source
  guard :rubocop, all_on_start: false do
    watch(%r{^spec/.+\.rb$})
    watch(%r{^lib/.+\.rb$})
    watch(%r{^.+\.(rb|ru)$})
    watch 'Gemfile'
    watch 'Rakefile'
  end

  group :unit do
    guard :rspec, failed_mode: :none do
      watch(%r{^spec/unit/.+_spec\.rb$})
      watch(%r{^lib/(.+)\.rb$})     { |m| "spec/unit/lib/#{m[1]}_spec.rb" }
      watch('spec/spec_helper.rb')
    end
  end

  group :integration do
    guard :rspec do
      watch(%r{^spec/integration/.+_spec\.rb$})
      watch(%r{^lib/(.+)\.rb$})     { |m| "spec/integration/lib/#{m[1]}_spec.rb" }
      watch('spec/spec_helper.rb')
    end
  end

  group :system do
    guard :rspec, cmd: 'SYSTEM=true rspec' do
      watch(%r{^spec/system/.+_spec\.rb$})
      watch(%r{^lib/(.+)\.(rb|slim)$})     { |m| "spec/system/lib/#{m[1]}_spec.rb" }
      watch('spec/spec_helper.rb')
    end
  end
end

group :server do
  # Reload the server on source changes
  guard 'shotgun', :server => 'thin' do
    watch(%r{lib/.+\.rb})
    watch %r{lib/config/.*\.yml}
    watch 'config.ru'
  end

  # Reload the browser on file changes, requires chrome extension
  guard 'livereload' do
    watch(%r{^lib/views/.+\.slim})
    watch(%r{^lib/.+\.rb})
    watch(%r{lib/public/.+\..+})
    watch(%r{lib/config/.+\.yml})
    # Rails Assets Pipeline #TODO configure this
    watch(%r{(lib/assets/\w+/(.+\.(scss|css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  end
end
