gsub_file "app/assets/javascripts/application.js", /^.*require rails-ujs$/ do
  <<~JAVASCRIPT.strip
    //= require jquery
    //= require jquery_ujs
  JAVASCRIPT
end
