# ═══════════════════════════════════════════════════════════════
# IRB (Interactive Ruby) Configuration
# ═══════════════════════════════════════════════════════════════

# ═══════════════════════════════════════════════════════════════
# ENHANCED OUTPUT FORMATTING
# ═══════════════════════════════════════════════════════════════

# Try to load Amazing Print for beautiful output formatting
begin
  found_gem = Gem::Specification.find_by_name("amazing_print")
  require "amazing_print"
  AmazingPrint.irb!
rescue Gem::LoadError
  # Amazing Print not installed, no problem
end

# Try to load Dracula theme for IRB
begin
  found_gem = Gem::Specification.find_by_name("irb-theme-dracula")
  require "irb/theme/dracula/light"
rescue Gem::LoadError
  # Theme not installed, no problem
end

# ═══════════════════════════════════════════════════════════════
# USEFUL INTROSPECTION METHODS
# ═══════════════════════════════════════════════════════════════

class Class
  public :include

  # Show only this class's class methods (not inherited)
  def class_methods
    (methods - Class.instance_methods - Object.methods).sort
  end

  # Show instance methods defined in this class (not inherited)
  def local_methods
    (self.class.instance_methods(false) - Object.instance_methods).sort
  end

  # Show both instance and class methods defined in this class
  def defined_methods
    methods = {}
    methods[:instance] = new.local_methods rescue []
    methods[:class] = class_methods
    methods
  end
end

class Object
  # Show methods defined by the object's class (not Object methods)
  def defined_methods
    (methods - Object.instance_methods).sort
  end

  # Show instance methods from the object's class only
  def local_methods
    (self.class.instance_methods(false) - Object.instance_methods).sort
  end

  # Open a method's source location in your editor
  def ocode(method_name)
    file, line = method(method_name).source_location

    if file && line
      # Change this to your preferred editor
      # VS Code: `code -g '#{file}:#{line}'`
      # Sublime: `subl '#{file}:#{line}'`
      # Vim: `vim '#{file}' +#{line}`
      `code -g '#{file}:#{line}'`
      "Opening #{file}:#{line}"
    else
      "'#{method_name}' is a native method or cannot be located."
    end
  end

  # Show source code of a method (requires method_source gem)
  def source(method_name)
    method(method_name).source
  rescue NameError
    "Method '#{method_name}' not found"
  rescue
    "Source not available (may be a native method)"
  end
end

# ═══════════════════════════════════════════════════════════════
# HISTORY CONFIGURATION
# ═══════════════════════════════════════════════════════════════

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

# ═══════════════════════════════════════════════════════════════
# PROMPT CUSTOMIZATION
# ═══════════════════════════════════════════════════════════════

# Custom prompt showing Ruby version
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "rb:%n> ",     # Normal prompt
  :PROMPT_S => "rb:%n%l ",    # Continued string
  :PROMPT_C => "rb:%n* ",     # Continued statement
  :RETURN => "=> %s\n"        # Return value
}

# Use the custom prompt
# IRB.conf[:PROMPT_MODE] = :CUSTOM

# ═══════════════════════════════════════════════════════════════
# AUTO-COMPLETION
# ═══════════════════════════════════════════════════════════════

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_AUTOCOMPLETE] = true

# ═══════════════════════════════════════════════════════════════
# USEFUL SHORTCUTS & HELPERS
# ═══════════════════════════════════════════════════════════════

# Clear the screen
def clear
  system('clear')
end

# Reload the IRB configuration
def reload!
  load File.expand_path('~/.irbrc')
  "IRB configuration reloaded!"
end

# Benchmark a block of code
def benchmark(times = 1)
  require 'benchmark'
  result = nil
  timing = Benchmark.measure do
    times.times { result = yield }
  end
  puts "Execution time: #{timing.real} seconds (#{times} iterations)"
  result
end

# Quick way to measure time
def time
  start = Time.now
  result = yield
  puts "Elapsed time: #{Time.now - start} seconds"
  result
end

# Copy to clipboard (macOS)
def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
  "Copied to clipboard!"
end

# Paste from clipboard (macOS)
def paste
  `pbpaste`
end

# ═══════════════════════════════════════════════════════════════
# RAILS SPECIFIC (only loaded in Rails console)
# ═══════════════════════════════════════════════════════════════

if defined?(Rails) && Rails.env
  # Show Rails environment in prompt
  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{Rails.env}> ",
    :PROMPT_S => "#{Rails.env}%l ",
    :PROMPT_C => "#{Rails.env}* ",
    :RETURN => "=> %s\n"
  }
  IRB.conf[:PROMPT_MODE] = :RAILS

  # Shortcut for reload!
  def r!
    reload!
  end

  # SQL query helper
  def sql(query)
    ActiveRecord::Base.connection.execute(query)
  end

  # Show model's database columns
  def show_model(model)
    model.column_names.each do |col|
      puts "#{col}: #{model.columns_hash[col].type}"
    end
    nil
  end

  # Enable SQL query logging
  def show_sql
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    nil
  end

  # Disable SQL query logging
  def hide_sql
    ActiveRecord::Base.logger = nil
    nil
  end
end

# ═══════════════════════════════════════════════════════════════
# LOAD LOCAL CUSTOMIZATIONS
# ═══════════════════════════════════════════════════════════════

if File.exist?(File.expand_path('~/.irbrc.local'))
  load File.expand_path('~/.irbrc.local')
end

puts "IRB #{RUBY_VERSION} ready! Type 'defined_methods' on any object to explore."