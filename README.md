# rzheng.xyz
My academic website, powered by typst and gemini.

Inspirited by Apple Liquid Glass, the nav bar will collapse following your gesture.


## Credits
This project stands on the shoulders of the open-source community. Thanks to:
- [Academicons](https://jpswalsh.github.io/academicons/) — For providing the beautiful academic platform icons (HAL, ORCID, etc.).


## TODO:

- [] BIB, abstract in `Publications`.
    - Idea: to show BIB, I will use `tooltip`, with a button named `copy`. 
    - Idea: to show abstract, I will use `<details>` and `<summary>` 
- [] Support coauthors in `Publications`.
- [] Reorganizes the `.css` files.
    - [*] open a new file `maincard.css`.
- [] Reorganizes the `font-size`.
- [] Use checkbox hack to rewrite `cite.js`.
    - Idea: `.container:has(#toggle:checked) .my-link {}`. --- Due to the [issue](https://github.com/typst/typst/issues/5907), it does not work.
