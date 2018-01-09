import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], y = rd[1]/1000;
  foreach (u; 0..n+1)
    foreach (v; 0..n+1) {
      auto w = n-u-v;
      if (w >= 0 && 10*u+5*v+w == y) {
        writeln(u, " ", v, " ", w);
        return;
      }
    }
  writeln("-1 -1 -1");
}
