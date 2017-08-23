import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

const inf = 10L ^^ 15 + 1;

version(unittest) {} else
void main()
{
  auto q = readln.chomp.to!size_t;
  auto di = new int[](q), xi = new int[](q), ti = new long[](q);
  foreach (i; 0..q) {
    auto rd = readln.split;
    di[i] = rd[0].to!int; xi[i] = rd[1].to!int; ti[i] = rd[2].to!long;
  }

  auto maxXD = zip(di, xi).map!"a[0] + a[1]".maxElement - 1;
  auto pt = pascalTriangle!long(maxXD);

  foreach (d, x, t; lockstep(di, xi, ti)) {
    auto c = pt[x+d-1][d-1];
    writeln(c <= t ? "AC" : "ZETUBOU");
  }
}

pure T[][] pascalTriangle(T)(size_t n)
{
  auto t = new T[][](n + 1);
  t[0] = new T[](1);
  t[0][0] = 1;
  foreach (i; 1..n+1) {
    t[i] = new T[](i + 1);
    t[i][0] = t[i][$-1] = 1;
    foreach (j; 1..i)
      t[i][j] = min(inf, t[i - 1][j - 1] + t[i - 1][j]);
  }
  return t;
}
