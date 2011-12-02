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
name  = "Panasonic" # !!! remember Sardinia
activ = "1"
#End Input Data

doc = { "NAME"  => name, "ACTIV" => activ  }

#require "rubygems"
require "mongo" # Need for MongoDB

begin  # begin programs (block check on error) rescue->exception at an error

    db = Mongo::Connection.new("localhost").db("butler3") # open db 
    coll_company = db.collection("COMPANY") # access collection company
  
    companyDB = coll_company.find_one( doc ) # Read company from companyDB FOR TEST Duplication

    if companyDB  == nil # TEST ->Duplication (CompanyNot in CompanyDB)
 
           if coll_company.insert(doc)  != nil    # Insert Company
                    companyDB = coll_company.find_one( doc ) # Read Company from CompanyDB FOR TEST
                    puts "Inserting Company\n #{companyDB["NAME"]} --- #{companyDB["ACTIV"]}\n" # print Company
           else
                    puts ".-=ERROR Company Insert=-." # print ERROR
           end  
    else
           puts ".-=Duplication. Not INSERT. Company True in CompanyDB=-." # print Not  INSERT          
    end

            #-----Error Except-----#
rescue  => ex      # exception at an error
    puts "#{$@}\n-->#{$!}\n====>#{ex.class}\n----#{ex.message}\n++++++++++++"
ensure             # All Ok OR!!! Error -> Close File
    # block all executed (close for example)
end # end programs
