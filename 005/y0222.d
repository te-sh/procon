import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  auto ci = s.matchFirst(r"([+-]?\d+)([+-])([+-]?\d+)");
  auto x = ci[1].to!int, op = ci[2], y = ci[3].to!int;

  writeln(op.predSwitch("+", x - y, "-", x + y));
}
