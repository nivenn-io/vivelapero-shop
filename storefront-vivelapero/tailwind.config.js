/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#fef5ee',
          100: '#fde8d7',
          200: '#fbcdae',
          300: '#f8ab7b',
          400: '#f47e46',
          500: '#f15a20',
          600: '#e24216',
          700: '#bb2f14',
          800: '#952718',
          900: '#792316',
        },
      },
    },
  },
  plugins: [],
};
