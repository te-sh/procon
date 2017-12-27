import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  writeln(s[1] == s[2] && (s[0] == s[1] || s[2] == s[3]) ? "Yes" : "No");
}
