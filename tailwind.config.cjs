// let lumoPurple = "#903896";
let lumoPurple = "#B200ED";
let lumoGreen = "#00ff2b";

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.res.mjs"],
  theme: {
    extend: {
      colors: {
        primary: lumoPurple,
      },
    },
  },
  plugins: [],
};
