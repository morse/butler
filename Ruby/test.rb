 
	#cmd = "wget -t 2 -T 10 --delete-after -o /opt/logfile.txt http://www.yandex.ru" #2>&1

	cmd = "wget -t 2 -T 10 --delete-after http://www.yandex.ru 2>&1" # !!!!!!!!!!!
	 str = `#{cmd}`    # Executed command Operation System ( save out in

	# str = IO.read("/opt/logfile.txt") # read file logfile.txt in str
 
																		   #2011-11-10 22:01:48 (2,44 MB/s)   
																		   #2011-11-10 21:58:03 (287 KB/s) 
  answer = str.scan( /\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d \((\d{1,2}\,\d{1,2}\s\w\w\/s|\d{1,3}\s\w\w\/s)/)#.to_s
