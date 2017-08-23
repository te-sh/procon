import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto r = int.max;

  while (s.length >= 3) {
    if (s[0] == 'c') {
      auto m = s.matchFirst(r"^c[^w]*?w[^w]*?w");
      if (!m.empty) r = min(r, m[0].length.to!int);
    }
    s = s[1..$];
  }
  writeln(r == int.max ? -1 : r);
}
