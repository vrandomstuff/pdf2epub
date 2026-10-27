#include <stddef.h>
#include "tinyfiledialogs.h"

int main() {
  char* file = tinyfd_openFileDialog(NULL,NULL,0,NULL,NULL,0);
  tinyfd_messageBox(NULL,file,"ok","info",0);
  return 0;
}
