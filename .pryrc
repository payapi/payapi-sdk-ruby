Pry.config.editor = "vim --nofork"

# Print Ruby version at startup
Pry.config.hooks.add_hook(:when_started, :say_hi) do
  puts "Using Ruby version #{RUBY_VERSION}"
  dir = `pwd`.chomp
  dirs_added = []
  %w(test lib).map{ |d| "#{dir}/#{d}" }.each do |p|
    if File.exist?(p) && !$:.include?(p)
      $: << p
      dirs_added << p
    end
  end
  puts "Added #{ dirs_added.join(", ") } to load path in ~/.pryrc." if dirs_added

  begin
    require 'awesome_print'
    Pry.config.print = proc { |output, value| output.puts value.ai }
    AwesomePrint.pry!
    puts "Awesome print :)"
  rescue LoadError => err
    puts "no awesome_print :("
  end
end
