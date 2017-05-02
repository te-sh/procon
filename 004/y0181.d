import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]);
  writeln(calc(rd[0], rd[1], rd[2]));
}

auto calc(long a, long n, long m)
{
  if (m == 1) return 0L;
  if (n == 0) return 1L;

  auto c = calcCyc(a, m);
  auto t = modTet(a, n - 1, m);

  if (t < 0)
    return modPow(a, m + calc(a, n - 1, c) - m % c, m);
  else
    return modPow(a, t, m);
}

auto calcCyc(long a, long m)
{
  auto bi = new size_t[](m);
  bi[] = size_t.max;
  auto ci = new long[](m*2);
  ci[0] = 1;
  foreach (i; 1..m*2) {
    ci[i] = ci[i-1] * a % m;
    if (bi[ci[i]] != size_t.max)
      return i - bi[ci[i]];
    else
      bi[ci[i]] = i;
  }
  assert(0);
}

auto modPow(long a, long n, long m)
{
  if (m == 1) return 0L;
  if (n == 0) return 1L;

  auto r = 1L, s = a;
  while (n > 0) {
    if (n & 1)
      r = (r * s) % m;
    s = (s * s) % m;
    n >>= 1;
  }

  return r;
}

auto modTet(long a, long n, long m)
{
  long r;
  if (n == 0) {
    return 1L;
  } else if (n == 1) {
    r = a;
  } else if (n == 2) {
    if (a >= 5) return -1L;
    r = a ^^ a;
  } else if (n == 3) {
    if (a >= 3) return -1L;
    r = a ^^ (a ^^ a);
  } else {
    return -1L;
  }
  return r >= m ? -1L : r;
}
