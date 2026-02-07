#include "nma_gapp.h"

int main(int argc, char** argv) {
  g_autoptr(NmaGapp) app = nma_gapp_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
