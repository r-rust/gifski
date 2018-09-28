#' Gifski
#'
#' Gifski converts image frames to high quality GIF animations. Either provide input
#' png files, or automatically render animated graphics from the R graphics device.
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
#' png_path <- file.path(tempdir(), "frame%03d.png")
#' png(png_path)
#' par(ask = FALSE)
#' for(i in 1:10)
#'   plot(rnorm(i * 10), main = i)
#' dev.off()
#' png_files <- sprintf(png_path, 1:10)
#' gif_file <- tempfile(fileext = ".gif")
#' gifski(png_files, gif_file)
#' unlink(png_files)
#' \donttest{utils::browseURL(gif_file)}
#'
gifski <- function(png_files, gif_file = 'animation.gif', width = 800, height = 600, delay = 1, loop = TRUE, progress = TRUE){
  png_files <- normalizePath(png_files, mustWork = TRUE)
  gif_file <- normalizePath(gif_file, mustWork = FALSE)
  if(!file.exists(dirname(gif_file)))
    stop("Target directory does not exist:", dirname(gif_file))
  width <- as.integer(width)
  height <- as.integer(height)
  delay <- as.integer(delay * 100)
  loop <- as.logical(loop)
  progress <- as.logical(progress)
  .Call(R_png_to_gif, enc2utf8(png_files), enc2utf8(gif_file), width, height, delay, loop, progress)
}

#' @export
#' @rdname gifski
#' @param expr an R expression that creates graphics
#' @param ... other graphical parameters passed to \link{png}
#' @examples
#' \donttest{
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
#'
#' # High Definition images:
#' gif_file <- file.path(tempdir(), 'gapminder.gif')
#' save_gif(makeplot(), gif_file, 1280, 720, res = 144)
#' utils::browseURL(gif_file)}
save_gif <- function(expr, gif_file = 'animation.gif', width = 800, height = 600, delay = 1,
                     loop = TRUE, progress = TRUE, ...){
  imgdir <- tempfile('tmppng')
  dir.create(imgdir)
  on.exit(unlink(imgdir, recursive = TRUE))
  filename <- file.path(imgdir, "tmpimg_%05d.png")
  grDevices::png(filename, width = width, height = height, ...)
  graphics::par(ask = FALSE)
  tryCatch(eval(expr), finally = grDevices::dev.off())
  images <- list.files(imgdir, pattern = 'tmpimg_\\d{5}.png', full.names = TRUE)
  gifski(images, gif_file = gif_file, width = width, height = height, delay = delay, loop = loop, progress = progress)
}
