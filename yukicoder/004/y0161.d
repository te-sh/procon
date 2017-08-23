import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), g = rd[0], c = rd[1], p = rd[2];
  auto s = readln.chomp;

  auto fg = 0, fc = 0, fp = 0;
  foreach (f; s) {
    switch (f) {
    case 'G': ++fg; break;
    case 'C': ++fc; break;
    case 'P': ++fp; break;
    default: assert(0);
    }
  }

  auto r = 0;
  int a;

  a = min(g, fc); g -= a; fc -= a; r += a * 3;
  a = min(c, fp); c -= a; fp -= a; r += a * 3;
  a = min(p, fg); p -= a; fg -= a; r += a * 3;
  a = min(g, fg); r += a;
  a = min(c, fc); r += a;
  a = min(p, fp); r += a;

  writeln(r);
}
