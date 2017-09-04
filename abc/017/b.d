import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  writeln(s.matchAll(r"^(ch|o|k|u)*$").empty ? "NO" : "YES");
}
