import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto gi = new int[](max(3, n + 1));
  gi[2] = 1;

  foreach (i; 3..n+1) {
    auto g1 = gi[i / 2] ^ gi[(i + 1) / 2];
    auto g2 = gi[i / 3] ^ gi[(i + 1) / 3] ^ gi[(i + 2) / 3];
    gi[i] = mex([g1, g2]);
  }

  writeln(gi[n] == 0 ? "B" : "A");
}

auto mex(T)(T[] gi)
{
  auto ma = gi.length.to!T;
  foreach (i; ma.iota)
    if (!gi.canFind(i)) return i;
  return ma;
}
