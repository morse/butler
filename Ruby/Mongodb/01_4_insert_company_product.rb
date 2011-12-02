=begin
****************************************************************
27.10.2011
Butler
Mongodb Ruby

Mironenko O.I. Moscow
Mironenko I.O. Italy
Matteo Ratti Italy
*****************************************************************
=end

#Input Data 
product = "Vodka"
company = "Arsenal" # company -> _ref -> product
#End Input Data

#require "rubygems"
require "mongo" # Need for MongoDB

begin  # begin programs (block check on error) rescue->exception at an error
 
    db = Mongo::Connection.new("localhost").db("butler3") # open db 
    coll_company = db.collection("COMPANY") # access collection company
    coll_product   = db.collection("PRODUCT") # access collection product

    row_product = coll_product.find_one( "NAME" => product ) # FOR TEST find product (id==row_product["_id"])
    
    if row_product != nil   # TRUE product in PRODUCT_DB
        row_company = coll_company.find_one( "NAME" => company ) # FOR TEST 
            
        if row_company != nil   # TRUE company in COMPANY_DB
            coll_company.update( {"NAME"  => company }, # condition
                                        {"$push" => {"PRODUCTS" => {"_ref"=>row_product["_id"]}}}) # Write _ref
            puts "Product: [ #{product} ] insert in db"     # print -> insert in db
        else  # Not company in COMPANY_DB
                puts ".-=ERROR  Not Company at COMPANY_DB=-." # print Not Product
        end
            
    else  # Not product in PRODUCT_DB
        puts ".-=ERROR  Not Product at PRODUCT_DB=-." # print Not Product
    end  

            #-----Error Except-----#
rescue  => ex      # exception at an error
    puts "#{$@}\n-->#{$!}\n====>#{ex.class}\n----#{ex.message}\n***"
ensure             # All Ok OR!!! Error -> Close File
    # block all executed (close for example)
end # end programs


