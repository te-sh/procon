import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ans = 0;
  foreach (_; 0..n) {
    auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];
    ans += a * b;
  }
  writeln(ans * 21 / 20);
}
