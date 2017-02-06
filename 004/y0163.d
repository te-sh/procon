import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.uni;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.to!dstring.dup;

  foreach (ref c; s) {
    if (c.isLower) c = c.toUpper;
    else if (c.isUpper) c = c.toLower;
  }

  writeln(s);
}
