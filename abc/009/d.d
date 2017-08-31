import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), k = rd[0], m = rd[1];
  auto a = readln.split.to!(uint[]);
  auto c = readln.split.to!(uint[]);

  if (m <= k) {
    writeln(a[m-1]);
    return;
  }

  a.reverse();

  auto s = new uint[][](k, k);
  s[0][] = c[];
  foreach (i; 0..k-1) s[i+1][i] = uint.max;

  auto u = new uint[][](k, k);
  foreach (i; 0..k) u[i][i] = uint.max;

  auto t = repeatedSquare!(uint[][], matMul, int)(s, m-k, u);

  auto r = uint(0);
  foreach (i; 0..k) r ^= t[0][i] & a[i];

  writeln(r);
}

auto matMul(uint[][] a, uint[][] b)
{
  auto n = a.length;
  auto c = new uint[][](n, n);

  foreach (i; 0..n)
    foreach (j; 0..n)
      foreach (k; 0..n)
        c[i][j] ^= a[i][k] & b[k][j];

  return c;
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}
