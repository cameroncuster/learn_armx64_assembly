#include <netpbm.h>

grayimage *color_to_gray( rgbimage *image )
{
	int i, j;
	grayimage *gray = allocate_grayimage( image->width, image->height );
	for( i = 0; i < image->height; i++ )
	{
		for( j = 0; j < image->width; j++ )
		{
			gray->rows[i][j] =
				( 54 * image->rows[i][j].red +
				184 * image->rows[i][j].green +
				18 * image->rows[i][j].blue ) / 256;
		}
	}
	return gray;
}
