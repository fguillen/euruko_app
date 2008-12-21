if ARGV[0].nil?
  puts "Indica la ruta al fichero" 
  exit
end

File.read(ARGV[0]).each do |line|
  if line =~ /^\s*test ".*" do$/
    line.gsub!( /\"\sdo\s*$/, "" )
    line.gsub!( /"/, "" )
    line.gsub!( /^\s*/, "" )
    line.gsub!( /\s/, "_" )
    line.gsub!( /^/, "def ")

    line = "  " + line
  end
  
  puts line
end