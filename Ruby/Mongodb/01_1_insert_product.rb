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

cod   = "777"
name  = "Viski"
price = "3.48"

#End Input Data
doc = {  "COD"  => cod, "NAME"  => name,"PRICE"   => price  }
#require "rubygems"
require "mongo" # Need for MongoDB

begin  # begin programs (block check on error) rescue->exception at an error
 
    db = Mongo::Connection.new("localhost").db("butler3") # open db 
    coll_product = db.collection("PRODUCT") #access collection product

    productDB = coll_product.find_one( doc ) # Read PRODUCT from productDB FOR TEST Duplication

   if productDB  == nil # TEST ->Duplication (Product Not in ProductsDB)

          if coll_product.insert(doc)  != nil    # Insert product
                   productDB = coll_product.find_one( doc ) # Read PRODUCT from productDB FOR TEST
                   puts "Inserting Product\n #{productDB["NAME"]} --- #{productDB["PRICE"]}---- #{productDB["COD"]}\n" # print PRODUCT
          else
                   puts ".-=ERROR Product Insert=-." # print ERROR
          end  
   else
          puts ".-=Duplication. Not INSERT. Product True in ProductDB=-." # print Not  INSERT          
   end
    
            #-----Error Except-----#
rescue  => ex      # exception at an error
    puts "#{$@}\n-->#{$!}\n====>#{ex.class}\n----#{ex.message}\n++++++++++++"
ensure             # All Ok OR!!! Error -> Close File
    # block all executed (close for example)
end # end programs

