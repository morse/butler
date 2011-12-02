#*******************BEGIN FUNCTIONS DECLARE*****************************
def print_futer 
                                                                               # !!!! Achtung %-14s format align left !!!
	company_line = sprintf( "|                        Company: %-14s               |", $arLine[0] ) 
	puts "+--------------------------------------------------------------+\n" 
	puts "|                                                              |\n"
	puts "#{company_line}\n"       # Print company          
	puts "|                                                              |\n"
	puts "+--------------------------------------------------------------+\n"
	puts "| N/N |      Product |    COD  | QUANTITY|    PRICE |   Total  | \n" 
	puts "|--------------------------------------------------------------+\n"
end

def print_button
	puts "+--------------------------------------------------------------+\n"
	total_line = sprintf( "|                       Total: |%8d |          | %8.2f |", $sum_QUANTITY , $total ) 
	puts "#{total_line}\n"                                    # Print Total
	$all_QUANTITY += $sum_QUANTITY   # Accumulate all_QUANTITY
	$all_Total +=  $sum_Total                           # Accumulate all_Total
end

def  print_line
	fTotal = $arLine[3].to_f  * $arLine[4].to_f  
	out_line = sprintf( "| %2d  | %12s | %7s | %7s |  %7s | %8.2f |", $i , $arLine[1], $arLine[2] , $arLine[3] ,  $arLine[4] ,  fTotal  ) 
	puts "#{out_line}\n"   #  Main Print
	$i =  $i + 1                        # Count N/N +1
	$sum_QUANTITY += $arLine[3].to_i   # Accumulate  sum_QUANTITY
	$sum_Total += fTotal                                  # Accumulate  sum_Total  
end
#*******************END FUNCTIONS DECLARE*****************************
                           #*******************BEGIN PROGRAMS********

                           #..................................Global Valuem......................
begin  # begin programs ( block check on error ) rescue  exception at an error

      $sum_QUANTITY  = 0
      $sum_Total  = 0.0
      $all_QUANTITY  = 0
      $all_Total  = 0.0
      $i = 1
      $total = 0.0  
      
      file = File.open( "/home/om/Ruby/in.txt", "r" )
      szLine  = file.gets                                       # read ferst line
      $arLine = szLine.strip.split( '#' )         # splin line szLine in global array $arLine ( $- >global )
      $company_Old = $arLine[0]                #Save Old value company
      
      puts "\n\n\n"
      puts "                                                " + Time.now.strftime("%Y-%m-%d %H:%M") + "\n" 
      print_futer
      print_line 
      
                   #***********MAIN  CYCLE**********
      
      while( szLine = file.gets )  
                                                    
          $arLine = szLine.strip.split( '#' ) # splin line szLine in global array $arLine ( $- >global )
          $company_New = $arLine[0] 
            
          if  $company_New == $company_Old      # !!!! Achtung Old Company (If New Company == Old Company) Then Print
              print_line
          else                                  # If New Company ( $Company_New != $Company_Old )
              print_button
              $i = 1 			    # !!! We clear all. Will be a new Company !!!  
              $sum_Total    = 0.0         # Achtung!!! 0.0 float format
              $sum_QUANTITY = 0           #Achtung!!! 0  decimal format 
              $company_Old  = $company_New
              print_futer  
              print_line     
          end
      end     #***********END MAIN  CYCLE**********
      
      print_button
      file.close
      
      puts "+==============================================================+\n"
      total_line = sprintf( "|                   All_Total: |%8d |          | %8.2f |",  $all_QUANTITY, $all_Total  ) 
      puts "#{total_line}\n"                   # Print Total
      puts "+==============================================================+\n"
      puts "                                                " + Time.now.strftime("%Y-%m-%d %H:%M") + "\n" 
      puts "\n\n\n"
                  #-----Error Except-----#
rescue  => ex      # exception at an error
    puts "#{$@}\n-->#{$!}\n====>#{ex.class}\n----#{ex.message}\n***"
ensure             # All Ok OR!!! Error -> Close File
    # block all executed (close for example)
end # end programs

