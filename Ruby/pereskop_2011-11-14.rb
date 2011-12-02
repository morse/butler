=begin
****************************************************************
				  To my favourite son it is devoted.
				  Remembering Sardinia 29-08-2011
				  My birthday.
				  55 years.
------------

07.11.2011
Pereskop PING & SPEED
Ruby
Mironenko O.I. Moscow
Mironenko I.O. Italy

[10-11-2011 21:38]  y=3.6 g=54.9 dns=5.5 srv=PING_OK!NR! spd=4,55 MB/s cpu=+37 md=+39 hdd=+42 Tp= 0.61

*****************************************************************
=end

def site_test( site,          # site ip or url ( 172.28.121.11 or google.com )
                site_alias,   # alias for print  ( g= ) 
                criterion,    # max time ping (120 )
                cnt,          # quantity of repetitions for error ( 3 . For Print ?-error , !-warning )
                wait          # of repetitions sleep sec ( 1 )
                )
  i = 0
  err = ""
  out = "#{site_alias}"
  
  while cnt > i  #  Cycle while 
      cmd = "ping -c 1 -i 1 -w 1 -W 1 " + site # Command formation
      str = `#{cmd}`     # Executed command Operation System
      if str.empty?      # ping TRUE ?
      then               # !!! ping error !!! 
          $err_print = 1 # print error
          sleep( wait )  # Wait
          i += 1         # Count Cycle +1
          err << "?"     # Formating string for error or warning
      else               # !!! ping YES !!! 
          ping_str=str.scan( /mdev = \d{1,3}\.\d/ ).to_s
          
          if ping_str.empty?      # ping no ->it is not resolved on server in firewall !!!
             err << "PING_OK!NR!" # Formating string for warning not resolved
             # err_print = 1      # print error if need print error
             return  "#{out}#{err}"  # return string (PING_OK!NR!)
          end
          
          start_poz=ping_str.index( /\d/ )
          ping_flt=ping_str[start_poz..start_poz+3].to_f  # string to float format
          if ping_flt > criterion # criterion warning
          then               # criterion >
              $err_print = 1 # print error
              sleep( wait )  # Wait sec
              i += 1         # Count Cycle +1
              err << "!"  # Formating string for error or warning
          else  #  ***** ALL OK  *****
              return "#{out}" + ping_flt.to_s # return from function ALL OK (no print)
          end
      end 
  end           # end while - Quantity of checks have settled
  err_print = 1 # print error
  return "#{out}#{err}"+ ping_flt.to_s # return from function ERROR (print)
end

############## MAIN PROGRAMS ##############

speed_crt = 100.0   #  KB/s  criterion min speed for warning 
$err_print = 0    # print error ( 0-Noprint 1-Print->errors )
spd = ""

tm_start = Time.now.to_f   # for timer
time_str = Time.now.strftime("%d-%m-%Y %H:%M")

begin  # begin programs ( block check on error ) rescue  exception at an error

#============== Test Ping Sites ===========
    yandex = site_test( "yandex.ru",     "y=",  100 , 3 , 5 )
    google = site_test( "google.ru",     "g=",  100 , 3 , 5 )
    dns    = site_test( "195.14.50.1",   "dns=", 50 , 3 , 5 )
    server = site_test( "89.179.155.114","srv=", 10 , 3 , 5 )

#========= Test speed download site yandex.ru ====
    cmd = "wget -t 2 -T 10 --delete-after -o logfile.txt http://www.yandex.ru"
    str = `#{cmd}`    # Executed command Operation System ( save out in logfile.txt )
    str = IO.read("logfile.txt") # read file logfile.txt in str
                                                                          #2011-11-10 22:01:48 (2,44 MB/s)   
                                                                          #2011-11-10 21:58:03 (287 KB/s) 
    speed = str.scan(  /\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d \((\d{1,2}\,\d{1,2}\s\w\w\/s|\d{1,3}\s\w\w\/s)/).to_s

    if speed.empty?
    then     # error site not response
         spd << "???" # Formating string for error and exit
         $err_print = 1             # print error
    else      # OK site read
        speed_arr = speed.split( ' ' ) # find position where begins  (       [2011-11-09 03:43:41 (3,72 MB/s  ] 
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
   
#============== CPU =======================
    cmd = "sensors" # Command formation
    str = `#{cmd}`  # Executed command Operation System
    cpu = str.scan( /CPU Temperature:   \+\d{1,2}\.\d/ ).to_s[21..23]

#============== MB  =======================
    cmd = "sensors" # Command formation
    str = `#{cmd}`  # Executed command Operation System
     mb = str.scan( /MB Temperature:    \+\d{1,2}\.\d/ ).to_s[21..23]
     
#============== hdd =======================     
    cmd = "hddtemp /dev/sda" # Command formation
    str = `#{cmd}`  # Executed command Operation System
    hdd = str.scan( /dev\/sda\: ST3160023AS\: \d{1,2}/ ).to_s[24..25] #<- Set you hdd !!!
    tm_stop = Time.now.to_f   # for Program work time
    tm_dur = sprintf( "%-6.2f", tm_stop - tm_start ) # Program work time
    
# For DEBUG    
    out_put = "[#{time_str}]  #{yandex} #{google} #{dns} #{server} spd=#{spd} cpu=#{cpu} md=#{mb} hdd=+#{hdd} time=#{tm_dur}"
    puts out_put
    
rescue => ex
  # exception at an error
    f = File.open( "/var/log/perescop.log", "a" )
      f.puts "#{$@}\n-->#{$!}\n====>#{ex.class}\n----#{ex.message}\n***"
    f.close  
 puts "#{$@}\n-->#{$!}\n====>#{ex.class}\n----#{ex.message}\n***"

ensure             # All Ok OR!!! Error -> Close File  block all executed (close for example)
#======== Print or No Print messages  ======
    if $err_print == 1 # if error -> print in file
        f = File.open( "/var/log/perescop.log", "a" )
    out_put = "[#{time_str}]  #{yandex} #{google} #{dns} #{server} spd=#{spd} cpu=#{cpu} md=#{mb} hdd=+#{hdd} time=#{tm_dur}"
          f.puts out_put
        f.close  
    end
end # end programs test begin
