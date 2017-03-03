require 'json'

ARGV.each do |filename|
  fail unless filename =~ /\.rbm$/

  data = File.open(filename, 'r') do |file|
    Marshal.load(file)
  end

  json_filename = filename.sub(/\.rbm$/, '.json')
  File.open(json_filename, 'w') do |file|
    file.puts(JSON.dump(data))
  end
end
