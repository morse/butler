<?
//*******************GLOBAL DECLARE VALUE********************************
//    Script is executed ---> Start timet
list($msec,$sec)=explode( " ",microtime() ) ;
$start = $sec + $msec ;


global $i ;
global $arLine ;
global $fTotal ;
global $Sum_Total ;
global $Sum_QUANTITY ;
global $All_Total ;                       // We collect All Total. Achtung!!! 
global $All_QUANTITY ;                    // We collect All QUANTITY. Achtung!!!    

//*******************BEGIN FUNCTIONS DECLARE*****************************
function Print_Futer( $Name_Firm )
{
                                                       // !!!! Achtung %-14s format align left !!!
           $company_line = sprintf( "|                        Company: %-14s               |", $Name_Firm ) ;
           echo("+--------------------------------------------------------------+\n" );
           echo("|                                                              |\n" );
           echo( $company_line . "\n" ) ;      // Print company          
           echo("|                                                              |\n" );
           echo("+--------------------------------------------------------------+\n" );
           echo("| N/N |      Product |    COD  | QUANTITY|    PRICE |   Total  | \n" );
           echo("|--------------------------------------------------------------+\n" );
   return 0 ;
}

function Print_Button( $QUANTITY, $Total )
{
           global $Sum_QUANTITY ;
           global $Sum_Total ;
           global $All_Total ;                       // We collect All Total. Achtung!!! 0. float format
           global $All_QUANTITY ;
           
           echo("+--------------------------------------------------------------+\n" );
           $total_line = sprintf( "|                       Total: |%8d |          | %8.2f |", $QUANTITY, $Total ) ;
           echo( $total_line . "\n" ) ;      // Print Total
           $All_QUANTITY += $Sum_QUANTITY ;  // Accumulate All_QUANTITY
           $All_Total    += $Sum_Total ;     // Accumulate All_Total
   return 0 ;
}

function Print_Line() 
{
           global $i ;
           global $arLine ;
           global $fTotal ;
           global $Sum_QUANTITY ;
           global $Sum_Total ;

           $fTotal = $arLine[3] * $arLine[4] ;
           $out_line = sprintf( "| %2d  | %12s | %7s | %7s |  %7s | %8.2f |", $i , $arLine[1], $arLine[2] , $arLine[3] ,  $arLine[4] ,  $fTotal  ) ;
           echo( $out_line . "\n" ) ;      //  Main Print
           $i++;                           // Count N/N +1
           $Sum_QUANTITY += $arLine[3] ;
           $Sum_Total += $fTotal ;

   return 0 ;
}

//*******************END FUNCTIONS DECLARE*****************************

//*******************BEGIN PROGRAMS************************************
echo( "\n\n\n" );                          // For appearance
echo( "\n                                                ".date("j.m.Y G:i")."\n" ); 
$szFile = "/home/om/ForMatteo/in.txt" ; // File for read
$file   = fopen( $szFile, "r");            // Open file

$szLine = trim( fgets( $file ) ) ;         // Read and Trim string in $szLine 
$arLine = explode( "#", $szLine );         // Split in Array $arLine             

$Company_Old = $arLine[0] ;                // Save Old value
Print_Futer( $Company_Old ) ;

$Sum_Total    = 0. ;                       // We collect Total. Achtung!!! 0. float format
$Sum_QUANTITY = 0 ;                        // We collect QUANTITY
$All_Total    = 0. ;                       // We collect All Total. Achtung!!! 0. float format
$All_QUANTITY = 0 ;                        // We collect All QUANTITY
$i = 1;                                    // For count N/N 

Print_Line() ;

                      /***********MAIN  CYCLE**********/
while ( $szLine= trim( fgets( $file ) ) )  
{
    $arLine = explode(  "#", $szLine ) ;   // Split in Array $arLine
    $Company_New = $arLine[0] ;
    
    if( $Company_New == $Company_Old )     // !!!! Achtung Old Company (If New Company == Old Company) Then Print
    {
           Print_Line() ;
    }
    else                                   // If New Company ( $Company_New != $Company_Old )
    {
           Print_Button( $Sum_QUANTITY, $Sum_Total ) ;
           // !!! We clear all. Will be a new Company !!!  
           $i = 1 ;
           $Sum_Total    = 0.;              // Achtung!!! 0. float format
           $Sum_QUANTITY = 0 ;              // Achtung!!! 0  decimal format 
           $Company_Old  = $Company_New = $arLine[0] ;
           Print_Futer( $Company_Old ) ;
           Print_Line() ;
    }
}                       /***********END MAIN  CYCLE**********/

Print_Button( $Sum_QUANTITY, $Sum_Total ) ;
echo("+==============================================================+\n" );
$total_line = sprintf( "|                   All_Total: |%8d |          | %8.2f |", $All_QUANTITY, $All_Total ) ;
echo( $total_line . "\n" ) ;      // Print Total
echo("+==============================================================+\n" );
echo( "                                                ".date("j.m.Y G:i")."\n" ); 

fclose( $file ) ;                          // close file
                                                                                          //    Script is executed
list($msec,$sec)=explode(" ",microtime());
$stop=$sec+$msec;
echo "                                  Script is executed: ".round($stop-$start,4)." sec" ;
echo( "\n\n\n" );                          // For appearance
?>