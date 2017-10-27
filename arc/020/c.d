import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = new long[](n), c = new long[](n), l = new long[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    c[i] = rd.front.length.to!long;
    a[i] = rd.front.to!long; rd.popFront();
    l[i] = rd.front.to!long;
  }
  auto mod = readln.chomp.to!int;

  auto b = new long[](n);
  b[$-1] = 0;
  foreach_reverse (i; 0..n-1)
    b[i] = b[i+1] + l[i+1] * c[i+1];

  auto ans = 0L;
  foreach (i; 0..n) {
    auto r = a[i] % mod;
    (r *= repeatedSquare(10L, b[i], mod)) %= mod;
    (r *= calc(l[i], c[i], mod)) %= mod;
    (ans += r) %= mod;
  }

  writeln(ans);
}

long calc(long l, long c, int mod)
{
  if (l == 1) return 1;
  auto ans = 0L;
  if (l % 2) ans += repeatedSquare(10L, (l-1)*c, mod);
  auto r = repeatedSquare(10L, (l/2)*c, mod);
  (r += 1) %= mod;
  (ans += (calc(l/2, c, mod) * r) % mod) %= mod;
  return ans;
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, U mod)
{
  return repeatedSquare(a, n, T(1), mod);
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init, U mod)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a) % mod;
    a = predFun(a, a) % mod;
    n >>= 1;
  }

  return r;
}
