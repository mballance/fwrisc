
#include "unit_header.h"

		entry:
			li		x1, 5
			li		x2, 5
			bne		x1, x2, 1f
			li		x3, 24
			j		done
		1:
			li		x3, 20
			j		done

start_expected:
.word 1, 5
.word 2, 5
.word 3, 24
end_expected:
