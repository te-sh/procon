import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, a = s.map!(c => cast(int)(c-'0')).sum, n = s.to!int;
  writeln(n%a == 0 ? "Yes" : "No");
}
