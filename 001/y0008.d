import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto p = readln.chomp.to!size_t;

  foreach (_; p.iota) {
    auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
    writeln((n < k || n % (k + 1) != 1) ? "Win" : "Lose");
  }
}
