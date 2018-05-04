[Spongedown](https://github.com/ivanceras/spongedown) is a wraps of markdown with
to multiple funky features added.

Funky features:
* [bob](https://github.com/ivanceras/svgbobrus/) diagrams
* csv
* comic/emoji faces

Wouldn't it be just cool if you could just incorporate
equations, diagrams and comics together with markdown.


```comic

                                                   +-----+------+
                                             .---> |-----|------|
                                            /      |-----|------|
                                           /       +-----+------+
                                          /                 .--.
                                         /                  |  |
                                        /                   v  |
  .-------.                            /           .-. .-. .-. |
  | Table |-.                         /        .-->'-' '-' '-' |
  '-------'  \                       / .-----> |     \  |  /   |
              \                     / /        |      v . v    |
.------------. \                   / /         '_______/ \_____|
| Flowcharts |--.                 / /                  \ /
'------------'   \               / /                    '---  ____
                  v _______     / /                     '--> /___/
.--------.         /       \---' /
| Graphs |------->/ Sponge  \---'-.
'--------'     .->\  down   /----. \           ^  .  /\  .-.
              / .->\_______/-.    \ \          |_/ \/  \/   \
.--------.   / /              \    \ `-------> +------------->
| Comics |--' /                \    \
'--------'   /                  \    \         +------------+
            /                    \    \        |   .-----.  |
   .----------.                   \    \       |  (       ) +------------+
   | Diagrams |                    \    \      |   `-, .-'  |  .-----.   |
   '----------'                     \    `---> |    /,'     | (       )  |
                                     \         |   /'       |  `-. .-'   |
                                      \        |            |     `.\    |
                                       \       | ٩(̾●̮̮̃ ̾•̃̾)۶    |       `\   |
                                        \      |            |            |
                                         \     +------------|   (,⊙–⊙,)७ |
                                          `--.              +------------+
                                              \
                                               v           .-,(  ),-.
                                            ___  _      .-(          )-.
                                           [___]|=| -->(                )      __________
                                           /::/ |_|     '-(          ).-' --->[_...__...°]
                                                           '-.( ).-'
                                                                   \      ____   __
                                                                    '--->|    | |==|
                                                                         |____| |  |
                                                                         /:::/  |__|

```
Support for table works as is.


Support for mathjax formula also works (inherited from mdbook)


\\[ \int x = \frac{x^2}{2} \\]

\\[ \mu = \frac{1}{N} \sum_{i=0} x_i \\]


Tables are supported as commonly markdown implementation does.

|  中文处理 | Data  |   CJK      |
|-----------|-------|------------|
|**Table**  | `are` | supported  |
| as        | well  |            |

CSV data are rendered as tables

```csv
foo,bar,baz
apple,banana,carrots
rust,haskel,c
```



The code used in writing this book is hosted in github
[here](https://github.com/ivanceras/Books/tree/master/spongedown_book)
and the source code used for generating the book is in
[here](https://github.com/ivanceras/aklat)

The following is the code for the page

{{#playpen Spongedown.md}}

- [Basic shapes](Basic_shapes.html)
- [Complex shapes](Comples_shapes.html)
