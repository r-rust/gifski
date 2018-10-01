#' Streaming Gifski Encoder
#'
#' Starts a stateful gif encoder and returns a closure to add png frames
#' to the gif. Upon completion, the caller has to invoke the closure one
#' more time with `png_file = NULL` to finalize the output.
#'
#' @export
#' @inheritParams gifski
#' @family gifski
#' @name streaming
#' @useDynLib gifski R_gifski_encoder_new
gifski_encoder_init <- function(gif_file = "animation.gif", width = 800, height = 600, loop = TRUE, delay = 1){
  gif_file <- normalizePath(gif_file, mustWork = FALSE)
  if(!file.exists(dirname(gif_file)))
    stop("Target directory does not exist:", dirname(gif_file))
  width <- as.integer(width)
  height <- as.integer(height)
  delay <- as.integer(delay * 100)
  loop <- as.logical(loop)
  ptr <- .Call(R_gifski_encoder_new, enc2utf8(gif_file), width, height, loop)
  function(png_file){
    if(is.character(png_file)){
      gifski_add_png(ptr, png_file, delay)
    } else if(is.null(png_file)){
      gifski_finalize(ptr)
    } else {
      stop("Invalid input: png_file must be a file path or NULL")
    }
  }
}

#' @useDynLib gifski R_gifski_encoder_add_png
gifski_add_png <- function(ptr, png_file, delay){
  png_file <- normalizePath(png_file, mustWork = TRUE)
  .Call(R_gifski_encoder_add_png, ptr, enc2utf8(png_file), delay)
}

#' @useDynLib gifski R_gifski_encoder_finalize
gifski_finalize <- function(ptr){
  .Call(R_gifski_encoder_finalize, ptr)
}
