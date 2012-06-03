/*
 * Ullrich von Bassewitz, 2012-05-30. Based on code by Groepaz.
 */

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include "dir.h"



DIR* __fastcall__ opendir (const char*)
{
    unsigned char buf[32];
    DIR* dir = 0;
    DIR d;

    /* Setup file name and offset */
    d.name[0] = '$';
    d.name[1] = '\0';
    d.off     = sizeof (buf);

    /* Open the directory on disk for reading */
    d.fd = open (d.name, O_RDONLY);
    if (d.fd >= 0) {

        /* Skip the disk header */
        if (_dirread (&d, buf, 32)) {

            /* Allocate memory for the DIR structure returned */
            dir = malloc (sizeof (*dir));

            /* Copy the contents of d */
            if (dir) {
                memcpy (dir, &d, sizeof (d));
            } else {
                /* Set an appropriate error code */
                errno = ENOMEM;
            }
        }
    }

    /* Done */
    return dir;
}



