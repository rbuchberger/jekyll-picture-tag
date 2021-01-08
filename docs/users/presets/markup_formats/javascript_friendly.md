---
sort: 2
---

# Javascript Friendly

These are analogous to their plain HTML counterparts, but instead of `src`,
`srcset`, and `sizes`, you get `data-src`, `data-srcset`, and `data-sizes`. This
allows you to use javascript for things like [lazy
loading](https://github.com/verlok/lazyload).

- `data_picture`

  ```html
    <picture>
      <source data-srcset="..." data-sizes="...">
      <source data-srcset="..." data-sizes="...">
      (...)
      <img data-src="...">
    </picture>
  ```

- `data_img`
  ```html
    <img data-srcset="..." data-src="..." data-sizes="...">
  ```

- `data_auto` - `data_picture` when needed, otherwise `data_img`.

## Special Options

The following preset settings only apply to these output formats.

- `noscript`

  _Format:_ `noscript: true|false`

  _Default:_ `false`

  Include a basic `img` fallback within a `<noscript>` tag, giving your
  non-javascript-running users something to look at.

  ```html
    <img data-srcset="..." data-src="..." data-sizes="...">
    <noscript>
      <img src="..." alt="...">
    </noscript>
  ```

- `data_sizes`

  _Format:_ `data_sizes: true|false`

  _Default:_ `true`

  This option sets whether you would like JPT's auto-generated sizes to be returned as a
  `data-sizes` attribute or a normal `sizes` attribute.

- `svg_placeholder`

  _Format:_ `svg_placeholder: true|false`

  _Default:_ `false`

  Sets the `src` attribute to a base64 encoded SVG, which is a simple transparent box with the
  correct aspect ratio. This is another method to prevent page reflow when loading images.
