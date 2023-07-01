module.exports = {
  plugins: ["stylelint-declaration-strict-value"],
  extends: ["stylelint-config-standard", "stylelint-prettier/recommended"],
  rules: {
    "color-hex-length": null,
    "declaration-empty-line-before": null,
    "declaration-no-important": true,
    "import-notation": null,
    "max-nesting-depth": 1,
    "no-empty-source": null,
    "no-invalid-position-at-import-rule": null,
    "property-no-unknown": [
      true,
      {
        // Allow property used for css-fonts-4 variable fonts
        ignoreProperties: ["font-named-instance"],
      },
    ],
    "scale-unlimited/declaration-strict-value": [
      "/color/",
      {
        disableFix: true,
        ignoreValues: [
          "currentcolor",
          "inherit",
          "initial",
          "transparent",
          "unset",
        ],
      },
    ],
    "selector-class-pattern": [
      // classes must be in BEM form, like this:
      // my_component
      // my_component--variant
      // my_component__element
      // my_component__element--variant
      // my_component__long_element_name
      // my_component__long_element_name--variant
      "^[a-z]+(_[a-z]+)*(__[a-z]+(_[a-z]+)*)?(--[a-z]+(_[a-z]+)*)*$",
      {
        resolveNestedSelectors: true,
        message:
          "Classes must be in BEM form like `my_component__element--variant`",
      },
    ],
    "selector-max-compound-selectors": 2,
    "selector-max-id": 0,
    "selector-no-qualifying-type": true,
    "shorthand-property-no-redundant-values": null,
  },
};
