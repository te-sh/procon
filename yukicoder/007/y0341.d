import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx
import std.uni;       // unicode

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto m = s.matchAll(r"…+");
  writeln(m.empty ? 0 : m.map!(mi => mi[0].walkLength).maxElement);
}
