import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, n = s.length;
  writeln((n % 2 == 0) ^ (s[0] == s[$-1]) ? "Second" : "First");
}
