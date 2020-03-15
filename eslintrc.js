module.exports = {
  plugins: ["jest", "prettier"],
  rules: {
    "no-unused-vars": [
      "error",
      {
        args: "after-used",
        argsIgnorePattern: "^_",
        varsIgnorePattern: "^_"
      }
    ],
    "no-var": "error",
    "prettier/prettier": "error"
  },
  extends: [
    // "react-app",
    "eslint:recommended",
    "plugin:jest/recommended",
    "prettier"
  ]
};
