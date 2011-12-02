=begin
****************************************************************
25.10.2011
Butler
Mongodb Ruby

Mironenko O.I. Moscow
Mironenko I.O. Italy
Matteo Ratti Italy
*****************************************************************
=end

#Input Data

name          = "Romeo7"
surname       = "Kazanova"
firm_name     = "Panasonic" # !!! remember
address       = "Olimp 22"
zip_code      = "088"
city          = "London"
num_tel       = "378-90-77"
director_name = "Jimmy Hendrix"
e_mail        = "Hendrix@am.com"
personal_tel  = "3333-444-3334"
telephon      = "367-757-5656"
#End Input Data

doc = { 'NAME'  => name,  'SURNAME'  => surname, 'FIRM_NAME' => firm_name, 'ADDRESS' => address,
	   'ZIP_CODE' => zip_code, 'CITY' => city, 'NUM_TEL' => num_tel,	'DIRECTOR_NAME'=> director_name,
	   'E-MAIL' => e_mail, 'PERSONAL_TEL' => personal_tel, 'TELEPHON' => telephon }
    
#require "rubygems"
require "mongo" # Need for MongoDB

begin  # begin programs (block check on error) rescue->exception at an error

    db = Mongo::Connection.new("localhost").db("butler3") # open db 
    coll_contact = db.collection("CONTACT") #access collection contact

	contactDB = coll_contact.find_one( doc ) # Read contact from contactDB FOR TEST
         
	if contactDB  == nil # TEST ->Duplication (Contact Not in CONTACTDB)   
						
			if coll_contact.insert(doc) != nil    # Insert contact
				contactDB = coll_contact.find_one( doc ) # Read contact from contactDB FOR TEST
				puts "Inserting contact\n #{contactDB["NAME"]} --- #{contactDB["SURNAME"]}---- #{contactDB["FIRM_NAME"]}\n" # print contact
			else
				puts ".-=Not insert contact=-." # print Not Contact
            end
    else
            puts ".-=Duplication. Not INSERT. Contact True in ContactDB=-." # print Not  INSERT          
    end						
						
            #-----Error Except-----#
rescue  => ex      # exception at an error
    puts "#{$@}\n-->#{$!}\n====>#{ex.class}\n----#{ex.message}\n++++++++++++"
ensure             # All Ok OR!!! Error -> Close File
    # block all executed (close for example)
end # end programs
