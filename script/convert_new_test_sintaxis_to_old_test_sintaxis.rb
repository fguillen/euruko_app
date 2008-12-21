if ARGV[0].nil?
  puts "Indica la ruta al fichero" 
  exit
end

if not File.exists?(ARGV[0])
  puts "Fichero no encontrado: #{ARGV[0]}" 
  exit
end

result = ""

File.open(ARGV[0]).read.each do |line|
  if line =~ /^\s*test ".*" do$/
    line.gsub!( /\"\sdo\s*/, "" )
    line.gsub!( /"/, "" )
    line.gsub!( /^\s*/, "" )
    line.gsub!( /\s/, "_" )
    line.gsub!( /^/, "def ")

    line = "  " + line + "\n"
  end
  
  result << line
end

File.new( ARGV[0], "w+" ).puts( result )