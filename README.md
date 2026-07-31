# rzheng.xyz
My academic website, powered by typst and gemini.

Inspirited by Apple Liquid Glass, the nav bar will collapse following your gesture.


## Credits
This project stands on the shoulders of the open-source community. Thanks to:
- [Academicons](https://jpswalsh.github.io/academicons/) — Academic platform icons (HAL, ORCID, etc.).
- [Fandol Fonts](https://ctan.org/pkg/fandol) — Open-source Chinese typography fonts.


## TODO:
- [ ] Coauthors. I will do it after my first co-work completed.
    - [ ] Coauthors tooltips, use `#show`.
    - [x] Support coauthors in `Publications`.
- [ ] Reorganizes the `.css` files.
    - [ ] Change most `px` to `em`.
    - [ ] Reorganizes the `font-size`.
    - [x] Abstract new file `maincard.css`.
- [ ] Use checkbox hack to rewrite `cite.js`.
    - Maybe it is not a good idea.
    - Idea: `.container:has(#toggle:checked) .my-link {}`. --- Due to the [issue](https://github.com/typst/typst/issues/5907), it does not work.
- [x] BIB, abstract in `Publications`.
    - [x] BIB, I will use `tooltip`, with a button named `copy`. 
    - [x] Abstract, I use `<details>` and `<summary>` 
