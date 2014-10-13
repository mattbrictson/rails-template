insert_into_file "app/assets/javascripts/application.js",
                 "//= require jquery.turbolinks\n",
                 :before => %r{^//= require turbolinks}

append_to_file "app/assets/javascripts/application.js",
               "\nTurbolinks.enableProgressBar();\n"
