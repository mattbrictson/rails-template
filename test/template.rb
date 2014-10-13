copy_file "test/test_helper.rb", :force => true
copy_file "test/helpers/javascript_helper_test.rb"
copy_file "test/helpers/retina_image_helper_test.rb"
copy_file "test/integration/layout_helper_test.rb"
empty_directory_with_keep_file "test/mailers"
empty_directory_with_keep_file "test/unit"
empty_directory_with_keep_file "test/unit/lib"
empty_directory_with_keep_file "test/unit/lib/tasks"
empty_directory_with_keep_file "test/unit/workers"
