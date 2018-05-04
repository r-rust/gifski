#' Gifski
#'
#' Gifski converts video frames to GIF animations using pngquant's fancy features
#' for efficient cross-frame palettes and temporal dithering. It produces animated
#' GIFs that use thousands of colors per frame.
#'
#' @export
#' @rdname gifski
#' @useDynLib gifski R_png_to_gif
#' @param png_files vector of png files
#' @param gif_file output gif file
#' @param width gif width in pixels
#' @param height gif height in pixel
#' @param delay time to show each image in seconds
#' @param loop should the gif play forever (FALSE to only play once)
#' @examples
#' png("frame%03d.png")
#' par(ask = FALSE)
#' for(i in 1:10)
#'   plot(rnorm(i * 10), main = i)
#' dev.off()
#' png_files <- sprintf("frame%03d.png", 1:10)
#' gif_file <- gifski(png_files)
#' unlink(png_files)
#' utils::browseURL(gif_file)
gifski <- function(png_files, gif_file = 'animation.gif', width = 480, height = 480, delay = 1, loop = TRUE){
  stopifnot(is.character(png_files))
  stopifnot(is.character(gif_file))
  width <- as.integer(width)
  height <- as.integer(height)
  delay <- as.integer(delay / 100)
  loop <- as.logical(loop)
  .Call(R_png_to_gif, png_files, gif_file, width, height, delay, loop)
}
