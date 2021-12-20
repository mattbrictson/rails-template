empty_directory_with_keep_file "app/assets/fonts"
empty_directory "app/assets/stylesheets/mixins"
copy_file "app/assets/stylesheets/colors.scss"
copy_file "app/assets/stylesheets/application.sass.scss", force: true
copy_file "app/assets/stylesheets/mixins/typography.scss"
