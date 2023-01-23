/**
 * Copy nbytes from src to dest
 */
void memory_copy(char* src, char* dest, int nbytes) {
	for (int i = 0; i < nbytes; i++)
		dest[i] = src[i];
}
