# gifski in R

[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/gifski)](http://cran.r-project.org/web/packages/gifski/index.html)


> gifski converts video frames to GIF animations using pngquant's fancy features
  for efficient cross-frame palettes and temporal dithering. It produces animated GIFs that
  use thousands of colors per frame.
  
This R package wraps the [gifski](https://crates.io/crates/gifski) cargo crate, see also the [website](https://gif.ski/).
  
## Examples

Minimal example from the `?gifski` manual page.

```r
png("frame%03d.png")
par(ask = FALSE)
for(i in 1:10)
  plot(rnorm(i * 10), main = i)
dev.off()
png_files <- sprintf("frame%03d.png", 1:10)
gif_file <- gifski(png_files)
unlink(png_files)
utils::browseURL(gif_file)
```

## Installation in R

The [hellorust readme](https://github.com/r-rust/hellorust#installation) has instructions on how to setup rust on Windows, MacOS or Linux. After that you can just do:

```r
devtools::install_github("r-rust/gifski")
```
