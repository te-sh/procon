import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, m = rd1[1].to!size_t, h = rd1[2].to!int;
  auto g = new size_t[][](n);
  foreach (_; 0..m) {
    auto rd2 = readln.splitter;
    auto f = rd2.front.to!size_t-1; rd2.popFront();
    auto t = rd2.front.to!size_t-1;
    g[f] ~= t;
  }
  auto d = new int[](n);
  foreach (i; 0..n) d[i] = readln.chomp.to!int;

  auto bt = new bool[][](n, h+1);
  foreach_reverse (i; 0..n-1)
    foreach (j; 1..h+1)
      bt[i][j] = g[i].empty || g[i].any!(v => j <= d[v]) || g[i].all!(v => bt[v][j-d[v]]);

  if (bt[0][h]) {
    writeln(-1);
    return;
  }

  auto calc(real x)
  {
    auto e = new real[][](n, h+1);
    e[n-1][] = 0;
    foreach_reverse (i; 0..n-1) {
      foreach (j; 1..h+1) {
        if (bt[i][j]) {
          e[i][j] = x+h-j;
        } else {
          e[i][j] = min(g[i].map!(v => e[v][j-d[v]]).reduce!"a+b" / g[i].length, x+h-j)+1;
        }
      }
    }
    return e[0][h];
  }

  auto eps = 1.0e-7L;
  struct XS { real x, s; }
  auto r = iota(eps, 1e6L+eps, eps).map!(x => XS(x, x-calc(x))).assumeSorted!"a.s < b.s".lowerBound(XS(0, 0));
  writefln("%.7f", r.back.x+eps);
}
