import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto mi = s.matchAll(r"([+*]?)(\d+)");

  auto acc = 0;
  foreach (m; mi) {
    auto op = m[1];
    auto arg = m[2].to!int;
    acc = op.predSwitch("", arg,
                        "+", acc * arg,
                        "*", acc + arg);
  }

  writeln(acc);
}
