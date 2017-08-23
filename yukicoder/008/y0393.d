import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto d = readln.chomp.to!size_t;
  foreach (_; 0..d) writeln(calc());
}

auto calc()
{
  auto n = readln.split.to!(int[]), maxN = n.maxElement;
  auto m = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  a.sort();

  auto w = new int[](n.length), k = 0;
  foreach (i, ni; n) {
    auto r = fill(ni, a[k..$]);
    k += r[0];
    w[i] = r[1];
  }

  if (k == m) return m;

  auto x = w.sum - a[k];
  if (x < 0) return k;

  auto dp1 = BitArray(), dp2 = BitArray();
  dp1.length = maxN + 1;
  dp2.length = maxN + 1;
  dp1[0] = true;

  foreach (i; 0..k) {
    (cast(size_t[]) dp2)[] = (cast(size_t[]) dp1)[];
    lshift(dp2, a[i]);
    dp1 |= dp2;
  }

  foreach (ni; n)
    foreach (i; max(ni-x, 0)..ni+1)
      if (dp1[i]) return k+1;

  return k;
}

auto fill(int n, int[] a)
{
  foreach (i, ai; a)
    if (n >= ai)
      n -= ai;
    else
      return Tuple!(size_t, int)(i, n);

  return Tuple!(size_t, int)(a.length, n);
}

auto lshift(ref BitArray ba, size_t i)
{
  if (i % 64 == 0) {
    if (i > 0) {
      ba <<= 1;
      ba <<= i-1;
    }
  } else {
    ba <<= i;
  }
}
