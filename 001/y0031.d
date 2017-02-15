import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, v = rd[1].to!long;
  auto ci = readln.split.to!(long[]);

  foreach (i, c; ci.drop(1)) ci[i + 1] = ci[i] + c;
  v -= n;

  if (v <= 0) {
    writeln(ci.back);
    return;
  }

  auto k = ci.enumerate!long
    .map!(ec => Tuple!(long, real)(ec.index, ec.value.to!real / (ec.index + 1))).array
    .sort!"a[1] < b[1]".front[0];

  auto dp = new long[]((k + 1) * n);
  dp[] = long.max;
  dp[0] = 0;

  foreach (i; n.iota) {
    auto dp2 = dp.dup;
    foreach (dpi, dpv; dp) {
      if (dpv != long.max) {
        foreach (j; (k + 1).iota) {
          auto idx = dpi + (i + 1) * j;
          if (idx < dp.length)
            dp2[idx] = min(dp2[idx], dpv + ci[i] * j);
        }
      }
    }
    dp = dp2;
  }

  auto r = dp.enumerate!long
    .filter!(d => d.value != long.max)
    .map!(d => d.value + (v - d.index + k) / (k + 1) * ci[k]);

  writeln(r.fold!min + ci.back);
}
