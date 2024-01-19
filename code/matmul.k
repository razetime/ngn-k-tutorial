matmul: {
  A::x
  B::y
  n::#A // no. of rows of A
  m::#*A // no. of col of A
  p::#*B // no. of cols of B
  C::(n;p)#0
  i::0
  j::0
  k::0
  sum::0
  {
    i::x
    {
      j::x
      sum::0
      {
        k::x
        sum::sum+A[i;k]*B[k;j] 
      }'!m
      C[i;j]::sum
    }'!p
  }'!n
  Ci}


/ Removing sum
matmul: {
  A::x
  B::y
  n::#A
  m::#*A
  p::#*B
  C::(n;p)#0
  i::0
  j::0
  k::0
  {
    i::x
    {
      j::x
      C[i;j]::+/{
        k::x
        A[i;k]*B[k;j] 
      }'!m
    }'!p
  }'!n
  C}


/ Removing C
matmul: {
  A::x
  B::y
  n::#A
  m::#*A
  p::#*B
  i::0
  j::0
  k::0
  {
    i::x
    {
      j::x
      +/{
        k::x
        A[i;k]*B[k;j] }'!m }'!p }'!n}

/ removing k and m
matmul: {
  A::x
  B::y
  n::#A
  p::#*B
  i::0
  j::0
  {
    i::x
    {
      j::x
      +/A[i]*B[;j] }'!p }'!n}

/ removing j and p
matmul: {
  A::x
  B::y
  n::#A
  i::0
  {
    i::x
      A[i]{+/x*y}/:+B}'!n }

/ removing i and n
matmul: {
  A::x
  B::y
  A{+/x*y}/:\:+B }

/ removing A and B
matmul: {x{+/x*y}/:\:+y}

/ remove the transpose
matmul: {x{+/x*y}\:y}

/ tacit
matmul: {x(+/*)\:y}
matmul: (+/*)\:

matmul[3 3#!9;=3]

