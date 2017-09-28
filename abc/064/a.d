import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rgb = readln.split.joiner.array.to!int;
  writeln(rgb % 4 == 0 ? "YES" : "NO");
}
