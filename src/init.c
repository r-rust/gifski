#define R_NO_REMAP
#define STRICT_R_HEADERS
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

extern SEXP R_gifski_encoder_add_png(SEXP, SEXP);
extern SEXP R_gifski_encoder_finalize(SEXP);
extern SEXP R_gifski_encoder_new(SEXP, SEXP, SEXP, SEXP);
extern SEXP R_png_to_gif(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"R_gifski_encoder_add_png",  (DL_FUNC) &R_gifski_encoder_add_png,  2},
  {"R_gifski_encoder_finalize", (DL_FUNC) &R_gifski_encoder_finalize, 1},
  {"R_gifski_encoder_new",      (DL_FUNC) &R_gifski_encoder_new,      4},
  {"R_png_to_gif",              (DL_FUNC) &R_png_to_gif,              7},
  {NULL, NULL, 0}
};

attribute_visible void R_init_gifski(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
