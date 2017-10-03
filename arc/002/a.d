import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.datetime;

version(unittest) {} else
void main()
{
  auto y = readln.chomp.to!int;
  auto d = Date(y, 1, 1);
  writeln(d.isLeapYear ? "YES" : "NO");
}
