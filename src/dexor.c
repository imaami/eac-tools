#ifndef _GNU_SOURCE
# define _GNU_SOURCE
#endif /* _GNU_SOURCE */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

enum {
	HEADER_SIZE = 1024u,
	LINE_LENGTH = 16u
};

static bool
read_header (const char *path,
             uint8_t    *dest);

static void
print_header (const uint8_t *data);

int
main (int    argc,
      char **argv)
{
	uint8_t data[1024];

	if (argc < 2 || argv[1] == NULL) {
		fprintf(stderr, "Usage: %s FILENAME\n", argv[0]);
		return EXIT_FAILURE;
	}

	if (!read_header((const char *)argv[1], data)) {
		return EXIT_FAILURE;
	}

	print_header((const uint8_t *)data);

	return EXIT_SUCCESS;
}

static bool
read_header (const char *path,
             uint8_t    *dest)
{
	bool success = false;
	int err_code = 0;
	const char *err_fn = NULL;

	do {
		FILE *stream;

		stream = fopen(path, "rbe");
		if (stream == NULL) {
			err_code = errno;
			err_fn = ": fopen";
			break;
		}

		success = (fread((void *)dest, 1u, HEADER_SIZE, stream) >= HEADER_SIZE);
		if (!success) {
			err_code = errno;

			if (ferror(stream) != 0) {
				/* read error */
				err_fn = ": fread";

			} else {
				/* file is smaller than HEADER_SIZE */
				err_code = ENODATA;
				err_fn = "";
			}
		}

		if (fclose(stream) != 0 && err_fn == NULL) {
			err_code = errno;
			err_fn = ": fclose";
		}
	} while(0);

	if (err_fn != NULL) {
		fprintf(stderr, "%s%s: %s\n", __func__, err_fn, strerror(err_code));
	}

	return success;
}

__attribute__ ((__always_inline__))
static inline uint8_t
dexor_byte (const uint8_t *data,
            unsigned int   offset)
{
	return data[offset] ^ ((offset * 3u) & 0xffu);
}

__attribute__ ((__always_inline__))
static inline void
print_hex_char (char    *dest,
                uint8_t  value)
{
	static const char HEX_DIGIT[16] = {
		'0', '1', '2', '3',
		'4', '5', '6', '7',
		'8', '9', 'a', 'b',
		'c', 'd', 'e', 'f'
	};
	dest[0] = HEX_DIGIT[value >> 4];
	dest[1] = HEX_DIGIT[value & 0xfu];
}

static void
print_header (const uint8_t *data)
{
	char line_buf[LINE_LENGTH * 3u];
	unsigned int data_left = HEADER_SIZE;
	unsigned int i = 0;

	while (data_left > 0u) {
		char *ptr = line_buf;
		unsigned int end = (data_left < LINE_LENGTH) ? data_left : LINE_LENGTH;
		data_left -= end;
		end += i;
		for (;;) {
			print_hex_char(ptr, dexor_byte(data, i));
			ptr += 2;
			if (++i >= end) {
				break;
			}
			*ptr++ = ' ';
		}
		*ptr = '\0';
		puts((const char *)line_buf);
	}
}
