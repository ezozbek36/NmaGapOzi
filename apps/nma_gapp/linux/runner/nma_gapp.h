#ifndef FLUTTER_NMA_GAPP_H_
#define FLUTTER_NMA_GAPP_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(NmaGapp, nma_gapp, NMA, GAPP, GtkApplication)

/**
 * nma_gapp_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #NmaGapp.
 */
NmaGapp* nma_gapp_new();

#endif  // FLUTTER_NMA_GAPP_H_
