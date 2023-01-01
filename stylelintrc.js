module.exports = {
  plugins: ["stylelint-declaration-use-variable"],
  extends: ["stylelint-config-standard"],
  rules: {
    "declaration-empty-line-before": null,
    "declaration-colon-newline-after": null,
    "declaration-no-important": true,
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
    "sh-waqar/declaration-use-variable": [
      [
        "/color/",
        {
          ignoreValues: [
            "currentcolor",
            "inherit",
            "initial",
            "transparent",
            "unset",
          ],
        },
      ],
    ],
    "string-quotes": "double",
    "value-list-comma-newline-after": null,
  },
};
