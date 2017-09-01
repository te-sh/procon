import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp.to!int;
  auto b = readln.chomp.to!int;

  auto a1 = a, r1 = 0;
  while (a1 != b) {
    ++a1; ++r1;
    if (a1 > 9) a1 = 0;
  }

  auto a2 = a, r2 = 0;
  while (a2 != b) {
    --a2; ++r2;
    if (a2 < 0) a2 = 9;
  }

  writeln(min(r1, r2));
}
