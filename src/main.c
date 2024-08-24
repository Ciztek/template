#include <stdio.h>

#include "local.h"

int main(void)
{
#if defined(DEBUG)
    puts("I am debug!");
#endif
    puts("hello!");
#if defined(FOO)
    puts("foo is set!");
    local_cflag_demo();
#endif
    return 0;
}
