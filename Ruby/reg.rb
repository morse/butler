  speed_crt = 100.0
  
   cmd = "wget -t 2 -T 10 --delete-after -o logfile.txt http://www.yandex.ru"
    str = `#{cmd}`    # Executed command Operation System ( save out in logfile.txt )
    str = IO.read("logfile.txt") # read file logfile.txt in str
                                                                          #2011-11-10 22:01:48 (2,44 MB/s)   
                                                                          #2011-11-10 21:58:03 (287 KB/s) 
    speed = str.scan( /\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d \(\d{1,2}\,\d{1,2}/ )
    wwww=/\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d \((\d{1,2}\,\d{1,2}\s\w\w\/s|\d{1,3}\s\w\w\/s)/=~str
    
    speed = str[wwww + 21..wwww + 30]
    
    
    if speed.empty?
    then     # error site not response
         spd << "???" # Formating string for error and exit
         $err_print = 1             # print error
    else      # OK site read
        bracket = speed.split( ')' )
        speed=bracket[0]
        speed_arr = speed.split( ' ' ) # find position where begins  (       [2011-11-09 03:43:41 (3,72 MB/s)  ] 
        speed_str = speed_arr[0]    # speed_str -> 3,72 (string!!!)
        speed_fld = speed_str.sub( ",", ".").to_f # replace , on .  and convert to float format
       if  !speed.scan( /MB/ ).empty? ### test MB/s -OR- KB/s ###
         speed_fld = speed_fld*1024.0    # MB -> KB
       end 
        if  speed_crt > speed_fld  # !!!!! criterion warning
        then          # criterion > warning
              spd = "!!!#{speed}" # Formating string for error or warning
              $err_print = 1             # print error
        else  #  ***** OK  SPEED*****
              spd = "#{speed}"    # Formating string for OK
        end 
    end
a=1