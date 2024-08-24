#include <stdint.h>
#include <stdlib.h>

#include "local.h"

int leak_memory(void)
{
    char *p = malloc(sizeof *p);

    return (int)(intptr_t)p;
}
