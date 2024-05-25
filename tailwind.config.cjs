// let lumoPurple = "#903896";
let lumoPurple = "#C614DD";
let lumoGreen = "#00ff2b";

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.res.mjs"],
  theme: {
    extend: {
      colors: {
        primary: lumoPurple,
        secondary: lumoGreen,
      },
      borderColor: {
        DEFAULT: lumoPurple,
      },
      fontSize: {
        xxxxs: ".4rem",
        xxxs: ".5rem",
        xxs: ".6rem",
      },
      maxHeight: {
        'screen-90': '90vh',
        'screen-70': '70vh',
      }
    },
  },
  plugins: [],
};
