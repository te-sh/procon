import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

const int p = 10 ^^ 9 + 7;

version(unittest) {} else
void main()
{
  auto bufFrac = new int[](2_000_000), sf = 1;
  bufFrac[0] = 1;

  auto bufInvFrac = new int[](2_000_000);
  bufInvFrac[] = -1;

  auto frac(int n) {
    if (sf <= n) {
      foreach (i; sf..n+1)
        bufFrac[i] = modMul(bufFrac[i - 1], i, p);
      sf = n + 1;
    }
    return bufFrac[n];
  }

  auto invFrac(int n) {
    if (bufInvFrac[n] == -1)
      bufInvFrac[n] = invMod(frac(n), p);
    return bufInvFrac[n];
  }

  auto t = readln.chomp.to!size_t;
  foreach (_; t.iota) {
    auto rd = readln.chomp;
    auto m = rd.matchFirst(r"([CPH])\((\d+),(\d+)\)");
    auto n = m[2].to!int, k = m[3].to!int;

    auto r = 0;
    switch (m[1]) {
    case "C":
      if (n >= k) {
        r = frac(n);
        r = modMul(r, invFrac(k), p);
        r = modMul(r, invFrac(n - k), p);
      }
      break;
    case "P":
      if (n >= k) {
        r = frac(n);
        r = modMul(r, invFrac(n - k), p);
      }
      break;
    case "H":
      if (n > 0) {
        r = frac(n + k - 1);
        r = modMul(r, invFrac(k), p);
        r = modMul(r, invFrac(n - 1), p);
      } else if (k == 0) {
        r = 1;
      }
      break;
    default:
      assert(0);
    }

    writeln(r);
  }
}

int modMul(int a, int b, int mod)
{
  return ((a.to!long * b.to!long) % mod).to!int;
}

T exEuclid(T)(T a, T b, ref T x, ref T y)
{
  auto g = a;
  x = 1;
  y = 0;
  if (b != 0) {
    g = exEuclid(b, a % b, y, x);
    y -= a / b * x;
  }
  return g;
}

T invMod(T)(T x, T m)
{
  T a, b;
  exEuclid(x, m, a, b);
  return ((a % m) + m) % m;
}
