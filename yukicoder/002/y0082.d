import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, w = rd[0].to!size_t, h = rd[1].to!size_t, c = rd[2];

  auto d = c == "B" ? 0 : 1;
  auto s = "BW".cycle;
  foreach (i; h.iota)
    s.drop((d + i) % 2).take(w).writeln;
}
