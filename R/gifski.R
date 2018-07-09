#' Gifski
#'
#' Gifski converts video frames to high quality GIF animations. Either provide your own
#' png files, or automatically save animated graphics from the R graphics device.
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
#' @param progress show progress bar
#' @examples
#' # Manually convert png files to gif
#' png("frame%03d.png")
#' par(ask = FALSE)
#' for(i in 1:10)
#'   plot(rnorm(i * 10), main = i)
#' dev.off()
#' png_files <- sprintf("frame%03d.png", 1:10)
#' gif_file <- gifski(png_files)
#' unlink(png_files)
#' \donttest{utils::browseURL(gif_file)}
#'
gifski <- function(png_files, gif_file = 'animation.gif', width = 480, height = 480, delay = 1, loop = TRUE, progress = TRUE){
  png_files <- normalizePath(png_files, mustWork = TRUE)
  stopifnot(is.character(gif_file))
  width <- as.integer(width)
  height <- as.integer(height)
  delay <- as.integer(delay * 100)
  loop <- as.logical(loop)
  progress <- as.logical(progress)
  .Call(R_png_to_gif, png_files, gif_file, width, height, delay, loop, progress)
}

#' @export
#' @rdname gifski
#' @param expr an R expression that creates graphics
#' @param res passed to \link{png}
#' @examples
#' # Example borrowed from gganimate
#' library(gapminder)
#' library(ggplot2)
#' makeplot <- function(){
#'   datalist <- split(gapminder, gapminder$year)
#'   lapply(datalist, function(data){
#'     p <- ggplot(data, aes(gdpPercap, lifeExp, size = pop, color = continent)) +
#'       scale_size("population", limits = range(gapminder$pop)) + geom_point() + ylim(20, 90) +
#'       scale_x_log10(limits = range(gapminder$gdpPercap)) + ggtitle(data$year) + theme_classic()
#'     print(p)
#'   })
#' }
#' gif_file <- save_gif(makeplot(), 'gapminder.gif')
#' \donttest{utils::browseURL(gif_file)}
save_gif <- function(expr, gif_file = 'animation.gif', width = 1280, height = 720, res = 144, delay = 1, loop = TRUE, progress = TRUE){
  imgdir <- tempfile('tmppng')
  dir.create(imgdir)
  on.exit(unlink(imgdir, recursive = TRUE))
  filename <- file.path(imgdir, "tmpimg_%05d.png")
  grDevices::png(filename, width = width, height = height, res = res, type = 'cairo')
  eval(expr)
  grDevices::dev.off()
  images <- list.files(imgdir, pattern = 'tmpimg_\\d{5}.png', full.names = TRUE)
  gifski(images, gif_file = gif_file, width = width, height = height, delay = delay, loop = loop, progress = progress)
}
