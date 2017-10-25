import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  struct Edge
  {
    int a, b;
    auto rev() { return Edge(b, a); }
  }

  auto e = new Edge[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int-1; rd2.popFront();
    auto b = rd2.front.to!int-1;
    e[i] = a < b ? Edge(a, b) : Edge(b, a);
  }

  auto u1 = new bool[](n);
  foreach (ei; e)
    if (ei.a == 0) u1[ei.b] = true;

  Edge[] f;

  foreach (ei; e)
    if (ei.a != 0) {
      if (u1[ei.a]) f ~= ei;
      if (u1[ei.b]) f ~= ei.rev;
    }

  auto fs = f.sort!"a.b < b.b";

  foreach (ei; e) {
    auto v1 = fs.equalRange(ei);
    auto v2 = fs.equalRange(ei.rev);

    foreach (v1i; v1)
      foreach (v2i; v2)
        if (v1i.a != v2i.a && v1i.a != v2i.b && v1i.b != v2i.a) {
          writeln("YES");
          return;
        }
  }

  writeln("NO");
}
