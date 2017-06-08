import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.ascii;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  s.filter!(c => c.isDigit).map!(c => (c - '0').to!int).sum.writeln;
}
