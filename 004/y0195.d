import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

const maxK = 39;
alias Tuple!(long, long) AB;

version(unittest) {} else
void main()
{
  auto xi = readln.split.to!(long[]);
  xi = xi.sort().uniq.array;

  auto fi = new long[](maxK);
  fi[0] = fi[1] = 1;
  foreach (i; 2..maxK)
    fi[i] = fi[i-1] + fi[i-2];

  if (xi.length == 1) {
    auto r = calc1(xi[0], fi);
    writeln(r[0], " ", r[1]);
  } else {
    auto r = calc2(xi[0], xi[1], xi.length == 3 ? xi[2] : -1, fi);
    if (r[0] == -1)
      writeln(-1);
    else
      writeln(r[0], " ", r[1]);
  }
}

auto calc1(long x, long[] fi)
{
  if (x == 1)
    return AB(1, 1);

  auto r = x - 1;
  foreach (i; 3..maxK) {
    auto t = x - fi[i-2];
    if (t <= 0 || t % fi[i-1]) continue;
    r = min(r, t / fi[i-1]);
  }

  return AB(1, r);
}

auto calc2(long x1, long x2, long x3, long[] fi)
{
  AB[] r = [];

  if (check(2, x1, x2, x3, fi)) r ~= AB(x1, x2);
  if (check(2, x2, x1, x3, fi)) r ~= AB(x2, x1);
  
  foreach (j; 2..maxK) {
    auto t = x2 - x1 * fi[j-2];
    if (t <= 0 || t % fi[j-1]) continue;
    auto b = t / fi[j-1];
    if (check(j+1, x1, b, x3, fi)) r ~= AB(x1, b);
  }

  foreach (j; 2..maxK) {
    auto t = x2 - x1 * fi[j-1];
    if (t <= 0 || t % fi[j-2]) continue;
    auto a = t / fi[j-2];
    if (check(j+1, a, x1, x3, fi)) r ~= AB(a, x1);
  }

  foreach (i; 2..maxK-1)
    foreach (j; i+1..maxK) {
      auto t = fi[j-2] * fi[i-1] - fi[i-2] * fi[j-1];
      auto x = x2 * fi[i-1] - x1 * fi[j-1];
      if (t < 0) {
        t = -t;
        x = -x;
      }
      if (x <= 0 || x % t) continue;
      auto a = x / t;

      auto u = x1 - a * fi[i-2];
      if (u <= 0 || u % fi[i-1]) continue;
      auto b = u / fi[i-1];

      if (check(j+1, a, b, x3, fi)) r ~= AB(a, b);
    }

  if (r.empty)
    return AB(-1, -1);
  else
    return r.sort!"a[0] == b[0] ? a[1] < b[1] : a[0] < b[0]".front;
}

auto check(size_t minK, long a, long b, long x3, long[] fi)
{
  if (x3 < 0) return true;

  foreach (k; minK..maxK)
    if (x3 == a * fi[k-2] + b * fi[k-1])
      return true;

  return false;
}
