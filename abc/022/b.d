import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  int[int] c;
  foreach (_; 0..n) {
    auto ai = readln.chomp.to!int;
    ++c[ai];
  }

  auto r = 0;
  foreach (ci; c.byValue) r += ci-1;

  writeln(r);
}
