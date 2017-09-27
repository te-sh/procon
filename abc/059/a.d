import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.uni;       // unicode

version(unittest) {} else
void main()
{
  auto s = readln.split;
  writeln(s.map!"a[0]".array.toUpper);
}
