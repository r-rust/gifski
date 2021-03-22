#define R_NO_REMAP
#define STRICT_R_HEADERS
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

// Import C headers for rust API
#include "myrustlib/gifski.h"

int cb(void *user_data){
  int *counter = user_data;
  *counter = (*counter)+1;
  //Rprintf("\rProcessing frame %d...", *counter);
  return 1;
}

SEXP R_png_to_gif(SEXP png_files, SEXP gif_file, SEXP width, SEXP height, SEXP delay, SEXP repeats, SEXP progress){
  if(!Rf_isString(png_files))
    Rf_error("png_files must be character vector");

  GifskiSettings settings = {0};
  settings.height = Rf_asInteger(height);
  settings.width = Rf_asInteger(width);
  settings.quality = 100;
  settings.fast = 0;
  settings.repeat = Rf_asInteger(repeats);
  gifski *g = gifski_new(&settings);

  /* Set a callback */
  int counter = 0;
  gifski_set_progress_callback(g, cb, &counter);
  gifski_set_file_output(g, CHAR(STRING_ELT(gif_file, 0)));

  /* add png frames in main thread */
  for(uint32_t i = 0; i < Rf_length(png_files); i++){
    double pts = i * Rf_asReal(delay);
    if(gifski_add_frame_png_file(g, i, CHAR(STRING_ELT(png_files, i)), pts) != GIFSKI_OK)
      REprintf("Failed to add frame %d\n", i);
    if(Rf_asLogical(progress))
      REprintf("\rInserting image %d at %.2fs (%d%%)...", (i+1), pts, (i+1) * 100 / Rf_length(png_files));
  }

  /* This will finalize the encoder thread as well */
  if(Rf_asLogical(progress))
    REprintf("\nEncoding to gif...");
  if(gifski_finish(g) != GIFSKI_OK)
    Rf_error("Failed gifski_finish");
  if(Rf_asLogical(progress))
    REprintf(" done!\n");
  return gif_file;
}

// Standard R package stuff
static const R_CallMethodDef CallEntries[] = {
  {"R_png_to_gif", (DL_FUNC) &R_png_to_gif, 7},
  {NULL, NULL, 0}
};

attribute_visible void R_init_gifski(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}

/* Workaround for linking error with experimental UCRT toolchain */
#ifdef _WIN32
#ifdef _UCRT
FILE * __cdecl __imp___iob_func(void){
  return NULL;
}
#endif
#endif
