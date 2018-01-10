import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  long a, b, c; read3(a, b, c);

  auto d = c / (a + b - 1);
  auto e = c % (a + b - 1);

  writeln(e <= a - 1 ? d * a + e : d * a + a);
}

void read3(S,T,U)(ref S a, ref T b, ref U c) { auto r = readln.splitter; a = r.front.to!S; r.popFront(); b = r.front.to!T; r.popFront(); c = r.front.to!U; }
