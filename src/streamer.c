#define R_NO_REMAP
#define STRICT_R_HEADERS
#include <Rinternals.h>

// Import C headers for rust API
#include <pthread.h>
#include <string.h>
#include "myrustlib/gifski.h"

/* data to pass to encoder thread */
typedef struct {
  int i;
  char *path;
  GifskiError err;
  gifski *g;
  GifskiSettings settings;
  pthread_t encoder_thread;
} gifski_ptr_info;

/* gifski_write() blocks until main thread calls gifski_end_adding_frames() */
static void * gifski_encoder_thread(void * data){
  gifski_ptr_info * info = data;
  info->err = gifski_write(info->g, info->path);
  return NULL;
}

static void fin_gifski_encoder(SEXP ptr){
  gifski_ptr_info *info = (gifski_ptr_info*) R_ExternalPtrAddr(ptr);
  if(info == NULL)
    return;
  R_SetExternalPtrAddr(ptr, NULL);
  if(info->encoder_thread)
    pthread_cancel(info->encoder_thread);
  gifski_drop(info->g);
  free(info->path);
  free(info);
}

static gifski_ptr_info *get_info(SEXP ptr){
  if(TYPEOF(ptr) != EXTPTRSXP || !Rf_inherits(ptr, "gifski_encoder"))
    Rf_error("pointer is not a gifski_encoder()");
  if(!R_ExternalPtrAddr(ptr))
    Rf_error("pointer is dead");
  return R_ExternalPtrAddr(ptr);
}

SEXP R_gifski_encoder_new(SEXP gif_file, SEXP width, SEXP height, SEXP loop){
  gifski_ptr_info *info = malloc(sizeof(gifski_ptr_info));
  info->path = strdup(CHAR(STRING_ELT(gif_file, 0)));
  info->settings.height = Rf_asInteger(height);
  info->settings.width = Rf_asInteger(width);
  info->settings.quality = 100;
  info->settings.fast = false;
  info->settings.once = !Rf_asLogical(loop);
  info->err = GIFSKI_OK;
  info->i = 0;
  info->g = gifski_new(&info->settings);
  if(pthread_create(&info->encoder_thread, NULL, gifski_encoder_thread, info))
    Rf_error("Failed to create encoder thread");
  SEXP ptr = R_MakeExternalPtr(info, R_NilValue, R_NilValue);
  Rf_setAttrib(ptr, R_ClassSymbol, Rf_mkString("gifski_encoder"));
  R_RegisterCFinalizerEx(ptr, fin_gifski_encoder, TRUE);
  return ptr;
}

SEXP R_gifski_encoder_add_png(SEXP ptr, SEXP png_file, SEXP delay){
  gifski_ptr_info *info = get_info(ptr);
  if(info->err != GIFSKI_OK)
    Rf_error("Gifski encoder is in bad state");
  const char *path = CHAR(STRING_ELT(png_file, 0));
  int d = Rf_asInteger(delay);
  if(gifski_add_frame_png_file(info->g, info->i, path, d) != GIFSKI_OK)
    Rf_error("Failed to add frame %d (%s)", info->i, path);
  info->i++;
  return Rf_ScalarInteger(info->i);
}

SEXP R_gifski_encoder_finalize(SEXP ptr){
  gifski_ptr_info *info = get_info(ptr);
  if(info->err != GIFSKI_OK)
    Rf_error("Gifski encoder is in bad state");
  if(gifski_end_adding_frames(info->g) != GIFSKI_OK)
    Rf_error("Failed to finalizer encoder");
  pthread_join(info->encoder_thread, NULL);
  info->encoder_thread = NULL;
  SEXP path = Rf_mkString(info->path);
  fin_gifski_encoder(ptr);
  return path;
}
