=begin
****************************************************************
26.10.2011
Butler
Mongodb Ruby

Mironenko O.I. Moscow
Mironenko I.O. Italy
Matteo Ratti Italy
*****************************************************************
=end

#Input Data 
product = "Bounty_Beag"
company = "Panasonic" # company -> _ref -> product # !!! remember Sardinia
#End Input Data

#require "rubygems"
require "mongo" # Need for MongoDB

begin  # begin programs (block check on error) rescue->exception at an error

    db = Mongo::Connection.new("localhost").db("butler3") # open db 
    coll_company = db.collection("COMPANY") # access collection company
    coll_product = db.collection("PRODUCT")    # access collection product
    
    coll_company.find().each do |row_company|
      puts "        #{row_company["NAME"]}"   # print COMPANY

      if row_company["PRODUCTS"] != nil     # Not company-->PRODUCTS
          
        row_company["PRODUCTS"].each do |row_product| # Do PRODUCTS
            
            productDB = coll_product.find_one("_id" => row_product["_ref"]) # Read PRODUCT from _ref in productDB
            puts "#{productDB["NAME"]} --- #{productDB["PRICE"]}---- #{productDB["COD"]}\n" # print PRODUCT
        end   # End Do row_product|
      else
          puts ".-=Not Products at Company=-." # print Not Products
      end    # End  if    
    end      # End Do row_company
    
                  #-----Error Except-----#
rescue  => ex      # exception at an error
    puts "#{$@}\n-->#{$!}\n====>#{ex.class}\n----#{ex.message}\n***"
ensure             # All Ok OR!!! Error -> Close File
          # block all executed (close for example)
end  # end programs
