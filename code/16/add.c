#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>
#include <k.h>
K add(K a,K b){
  N al=NK(a),bl=NK(b);
  C* ac=calloc(al+1,sizeof(C));C* bc=calloc(bl+1,sizeof(C));
  CK(ac,a);CK(bc,b);
  mpz_t big_a,big_b,r;
  mpz_init_set_str(big_a,ac,10);mpz_init_set_str(big_b,bc,10);mpz_init(r);
  mpz_add(r,big_a,big_b);
	return KC(mpz_get_str(NULL,10,r),al);
}
