import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

// path: arc070_b

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
  auto a = readln.split.to!(int[]);

  auto dp1 = new BitArray[](n+1), dp2 = new BitArray[](n+1);
  dp1[0].length = dp2[0].length = k;
  dp1[0][0] = dp2[0][0] = true;
  foreach (i; 0..n) {
    dp1[i+1] = dp1[i].dup;
    dp1[i+1].lshift(a[i]);
    dp1[i+1] |= dp1[i];

    dp2[i+1] = dp2[i].dup;
    dp2[i+1].lshift(a[$-i-1]);
    dp2[i+1] |= dp2[i];
  }

  auto check(int ai, BitArray dpi1, BitArray dpi2)
  {
    if (ai >= k) return true;
    auto mi = k-ai, cs = new int[](k);

    cs[0] = dpi2[0];
    foreach (j; 1..k) cs[j] = cs[j-1] + dpi2[j];

    foreach (j; 0..k) {
      auto mj = max(0, mi-j), c = cs[k-j-1] - cs[mj] + dpi2[mj];
      if (dpi1[j] & (c > 0)) return true;
    }

    return false;
  }

  auto ans = 0;
  foreach (i; 0..n) {
    auto dpi1 = dp1[i], dpi2 = dp2[n-i-1];
    ans += check(a[i], dpi1, dpi2);
  }

  writeln(n-ans);
}

auto lshift(ref BitArray ba, size_t n)
{
  if (n % 64 == 0) {
    if (n > 0) {
      ba <<= 1;
      ba <<= n-1;
    }
  } else {
    ba <<= n;
  }
}
