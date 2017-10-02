import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp;
  writeln(n[0] == n[2] ? "Yes" : "No");
}
