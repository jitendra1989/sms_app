class Jsonsdata < ActiveRecord::Base
	attr_accessor :upload



    def self.demo(upload)
        name =  upload['datafile'].original_filename
    directory = "upload/public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    end

 def self.save(upload,content_type)
    name =  upload['datafile'].original_filename
    directory = "upload/public/data"
    #content_type == "text/js"         
    # create the file path
    path = File.join(directory, name)
    # write the file
    #File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    #File.read(path) #{ |f| f.write(upload['datafile'].read) }

 File.extname(name)
  end
  def self.uploadfile(upload)
  	name =  upload['datafile'].original_filename
    directory = "upload/public/data"

#content_type == "text/js"
             
    # create the file path
    path = File.join(directory, name)
    # write the file
    #File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
        File.read(path) #{ |f| f.write(upload['datafile'].read) }
end

end
