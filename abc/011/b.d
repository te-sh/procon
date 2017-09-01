import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.uni;       // unicode

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  writeln(s[0..1].toUpper ~ s[1..$].toLower);
}
