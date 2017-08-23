import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);
  auto bi = readln.split.to!(int[]);

  auto si = new int[](101);
  foreach (a, b; lockstep(ai, bi))
    si[b] += a;

  writeln(si[0] >= si[1..$].maxElement ? "YES" : "NO");
}
