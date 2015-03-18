class DynamicMethod

  define_method(:no_args) do
    puts "no args passed"
  end

  define_method(:fixed_arg) do |val|
    puts "the arg passed was #{val}"
  end

  define_method(:variable_args) do |*args|
    puts "Number of args: #{args.length}"
    puts "List of args:"
    args.each { |arg| puts arg }
  end
end
