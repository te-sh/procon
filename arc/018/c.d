import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1];
  auto rd2 = readln.split.to!(int[]), x0 = rd2[0], a = rd2[1], p = rd2[2];

  if (a % p == 0) {
    if (x0 > p)
      writeln((n-1)*2);
    else
      writeln(0);

    return;
  }

  struct XI { int x, i; }
  auto xi = new XI[](n*m);
  xi[0] = XI(x0, 0);
  foreach (i; 1..n*m) xi[i] = XI((xi[i-1].x + a) % p, i);
  xi.sort!"a.x < b.x";

  auto ans = 0L;
  foreach (i; 0..n) {
    auto ci = new int[](m);
    foreach (j; 0..m) {
      auto k = xi[i*m+j].i, kr = k/m, kc = k%m;
      ans += (kr-i).abs;
      ci[j] = kc;
    }
    ci.sort();
    foreach (j; 0..m)
      ans += (ci[j]-j).abs;
  }

  writeln(ans);
}
