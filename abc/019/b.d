import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  char[] t;

  while (!s.empty) {
    auto c = s[0], i = 1;
    while (s[i] == c) ++i;
    t ~= format("%c%d", c, i);
    s = s[i..$];
  }

  writeln(t);
}
