import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto xy0 = readln.split.to!(int[]);
  auto a0 = xy0[1] - xy0[0];
  if (a0 <= 0) {
    writeln(-1);
    return;
  }

  foreach (_; 1..n) {
    auto xy = readln.split.to!(int[]);
    auto a = xy[1] - xy[0];
    if (a <= 0 || a != a0) {
      writeln(-1);
      return;
    }
  }

  writeln(a0);
}
