copy_file "bin/setup", :force => true
copy_file "bin/update", :force => true
chmod "bin/setup", "+x"
chmod "bin/update", "+x"
