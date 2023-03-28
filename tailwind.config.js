/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.{html,html.erb,erb,html.slim,slim}',
    './app/components/**/*.{html,html.erb,erb,html.slim,slim,js,ts,jsx,tsx}',
    './app/frontend/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
