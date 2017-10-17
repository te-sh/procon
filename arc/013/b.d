import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto c = readln.chomp.to!size_t;
  auto n = 0, m = 0, l = 0;
  foreach (_; 0..c) {
    auto b = readln.split.to!(int[]);
    b.sort();
    n = max(n, b[0]); m = max(m, b[1]); l = max(l, b[2]);
  }
  writeln(n*m*l);
}
