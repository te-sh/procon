import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, a = rd[0], b = rd[1], c = rd[2];
  writeln(a[$-1] == b[0] && b[$-1] == c[0] ? "YES" : "NO");
}
