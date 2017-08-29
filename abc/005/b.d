import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto r = int.max;

  foreach (_; 0..n) {
    auto t = readln.chomp.to!int;
    r = min(r, t);
  }

  writeln(r);
}
