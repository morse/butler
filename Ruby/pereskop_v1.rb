=begin
****************************************************************

------------
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

[10-11-2011 00:41]  y=3.1 g=54.8 dns=9.2 srv=PING_OK!NR! speed=4.28MB/s cpu=+37 md=+39 hdd=+42 Tp= 0.61

-t - число повторов
-T - seconds Время ожидания в секундах.
-nd - Не создавать структуру папок
-l -  Максимальная глубина рекурсивной загрузки 1
--delete-after Удалять каждую страницу (локально) после ее загрузки.
--page-requisites - для загрузки одной страницы полностью

wget -t 2 -T 10 -nd -l 1 --delete-after --page-requisites http://speedcheck.gldn.net/3Mb >> null

wget -o logfile linux.about.com
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
          
          if ping_str.empty? # ping no ->it is not resolved on server in firewall !!!
             err << "PING_OK!NR!" # Formating string for warning not resolved
             # err_print = 1 # print error if need print error
             return  "#{out}#{err}"  # return string (PING_OK!NR!)
          end
          
          start_poz=ping_str.index( /\d/ )
          ping_flt=ping_str[start_poz..start_poz+3].to_f  # string to float format
          if ping_flt > criterion # criterion warning
          then           # criterion >
              $err_print = 1 # print error
              sleep( wait )  # Wait sec
              i += 1     # Count Cycle +1
              err << "!" # Formating string for error or warning
          else  #  ***** ALL OK  *****
              return "#{out}" + ping_flt.to_s # return from function ALL OK (no print)
          end
      end 
  end           # end while - Quantity of checks have settled
  err_print = 1 # print error
  return "#{out}#{err}"+ ping_flt.to_s # return from function ERROR (print)
end

############## MAIN PROGRAMS ##############

speed_crt = 0.2 # criterion min speed for warning 
$err_print = 0    # print error ( 0-Noprint 1-Print->errors )
spd = ""

tm_start = Time.now.to_f

time_str = Time.now.strftime("%d-%m-%Y %H:%M")



#============== Test Ping Sites ===========
    yandex = site_test( "yandex.ru",     "y=",  100 , 3 , 5 )
    google = site_test( "google.ru",     "g=",  100 , 3 , 5 )
    dns    = site_test( "195.14.50.1",   "dns=", 50 , 3 , 5 )
    server = site_test( "89.179.155.114","srv=", 10 , 3 , 5 )

#========= Test speed download site yandex.ru ====
    cmd = "wget -t 2 -T 10 --delete-after -o logfile.txt http://yandex.ru"
    str = `#{cmd}`    # Executed command Operation System
    str = IO.read("logfile.txt")
                                     # pattern -> 2011-11-09 22:59:10 (1,58 MB/s)
    speed = str.scan( /\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d \(\d{1,2}\,\d{1,2}/ ).to_s
    if speed.empty?
    then
         spd << "???" # Formating string for error and exit
    else
        start_poz=speed.index( /\(/ )                 
        speed_fld=speed.to_s[ start_poz+1..start_poz+4 ].sub( ",", ".").to_f
   # speed_fld.
        if  speed_fld < speed_crt # criterion warning
        then           # criterion >
              spd = "!!!#{speed_fld.to_s}" # Formating string for error or warning
              err_print = 1                                # print error
        else  #  ***** OK  SPEED*****
              spd = "#{speed_fld.to_s}"  # Formating string for OK
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
    hdd = str.scan( /sda: ST3160023AS: \d{1,2}/ ).to_s[20..21] #<- Set you hdd !!!
   
    tm_stop = Time.now.to_f
    tm_dur = sprintf( "%-6.2f", tm_stop - tm_start )
    
    out_put = "[#{time_str}]  #{yandex} #{google} #{dns} #{server} spd=#{spd}MB/s cpu=#{cpu} md=#{mb} hdd=+#{hdd} tp=#{tm_dur}s"
    puts out_put
    
    
   
#======== Print or No Print messages  ======  
if $err_print == 1 # if error -> print in file
    f = File.open( "/var/log/perescop.log", "a" )
    out_put = "[#{time_str}]  #{yandex} #{google} #{dns} #{server} spd=#{spd}MB/s cpu=#{cpu} md=#{mb} hdd=+#{hdd} tp=#{tm_dur}s"
    f.puts out_put
    f.close  
end
