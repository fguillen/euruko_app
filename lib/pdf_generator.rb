class PDFGenerator
  def self.users_list( users, current_user )
    pdf = PDF::Writer.new
    users.each_with_index do |user,index|
      out = "#{"%03d" % index}, #{"%03d" % user.id}, #{user.name}"
      out += ", #{user.email}"  if current_user && current_user.admin?
      out += "\n"
      pdf.text out
    end
    pdf.render
  end
end