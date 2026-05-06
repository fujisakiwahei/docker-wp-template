module.exports = {
  proxy: "${ドメイン名}.local",
  files: ["*.css", "**/*.css", "assets/scss/**/*.scss", "assets/js/*.js", "**/*.php",  "*.php", "**/*.js",],
  scripts: {
    browser: "browser-sync start --config bs-config.js",
  },
};
