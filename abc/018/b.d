import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.dup;
  auto n = readln.chomp.to!size_t;
  foreach (_; 0..n) {
    auto rd = readln.split.to!(size_t[]), l = rd[0], r = rd[1];
    s[l-1..r].reverse();
  }
  writeln(s);
}
