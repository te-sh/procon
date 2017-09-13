import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), l = rd[0], h = rd[1];
  auto n = readln.chomp.to!size_t;
  foreach (_; 0..n) {
    auto a = readln.chomp.to!int;
    if (a < l)      writeln(l-a);
    else if (a > h) writeln(-1);
    else            writeln(0);
  }
}
