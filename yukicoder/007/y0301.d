import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -12

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  foreach (_; 0..n) {
    auto k = readln.chomp.to!long;
    if (k < 150) {
      auto ak = calcAk(k);
      writefln("%.13f", ak[1] / (1 - ak[0]));
    } else {
      writefln("%.13f", k + 5.0 / 3);
    }
  }
}


auto calcAk(T)(T k)
{
  real p = 1.0/6, u = 1;
  auto a = [[p,p,p,p,p,p,u],
            [u,0,0,0,0,0,0],
            [0,u,0,0,0,0,0],
            [0,0,u,0,0,0,0],
            [0,0,0,u,0,0,0],
            [0,0,0,0,u,0,0],
            [0,0,0,0,0,0,u]];

  auto i = [[u,0,0,0,0,0,0],
            [0,u,0,0,0,0,0],
            [0,0,u,0,0,0,0],
            [0,0,0,u,0,0,0],
            [0,0,0,0,u,0,0],
            [0,0,0,0,0,u,0],
            [0,0,0,0,0,0,u]];
  auto ak = repeatedSquare!(real[][], matMul)(a, k, i);
  return [ak[0][1..6].sum, ak[0][6]];
}

T[][] matMul(T)(T[][] a, T[][] b)
{
  import std.traits;
  auto l = b.length, m = a.length, n = b[0].length;
  auto c = new T[][](m, n);
  static if (isFloatingPoint!T) {
    foreach (ref r; c) r[] = T(0);
  }
  foreach (i; 0..m)
    foreach (j; 0..n)
      foreach (k; 0..l)
        c[i][j] += a[i][k] * b[k][j];
  return c;
}

T[] matMulVec(T)(T[][] a, T[] b)
{
  import std.traits;
  auto l = b.length, m = a.length;
  auto c = new T[](m);
  static if (isFloatingPoint!T) {
    c[] = T(0);
  }
  foreach (i; 0..m)
    foreach (j; 0..l)
      c[i] += a[i][j] * b[j];
  return c;
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  static T[] buf = new T[](32);
  static filled = 0;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}
