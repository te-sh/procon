import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc070_a

version(unittest) {} else
void main()
{
  auto x = readln.chomp.to!long;

  struct T { long t, y; }
  auto t = iota(0, x+1)
    .map!(t => T(t, t*(t+1)/2))
    .assumeSorted!"a.y < b.y"
    .lowerBound(T(0, x)).back.t;

  writeln(t+1);
}
