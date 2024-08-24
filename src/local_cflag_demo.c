#include <stdio.h>

#include "local.h"

#if defined(FOO)
void local_cflag_demo(void) {
    puts("oh no, very bad!");
}
#else
void local_cflag_demo(void)
{
    puts("good");
}
#endif
