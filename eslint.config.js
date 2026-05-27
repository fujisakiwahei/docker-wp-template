const js = require("@eslint/js");
const globals = require("globals");
const prettier = require("eslint-config-prettier");

module.exports = [
  js.configs.recommended,
  prettier,
  {
    files: ["wp-content/themes/main-theme/**/*.js"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "script",
      globals: {
        ...globals.browser,
        ...globals.jquery,
        wp: "readonly",
        ajaxurl: "readonly",
      },
    },
    rules: {
      "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
      "no-console": "warn",
      "no-var": "error",
      "prefer-const": "warn",
      eqeqeq: ["error", "always"],
    },
  },
  {
    ignores: [
      "node_modules/**",
      "wp-content/plugins/**",
      "wp-content/themes/main-theme/style.css",
      "wp-content/themes/main-theme/style.css.map",
      "**/*.min.js",
    ],
  },
];
