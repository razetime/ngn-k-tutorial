K_PATH=/home/razetime/code/k
run: libadd.so
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):$(K_PATH) $(K_PATH)/k add.k
libadd.so: add.c
	$(CC) -I$(K_PATH) -L$(K_PATH) -shared -fPIC $^ -o $@ -lk -lgmp
