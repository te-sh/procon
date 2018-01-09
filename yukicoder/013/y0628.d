import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  int[string] h;

  foreach (_; 0..n) {
    readln;
    auto rd = readln.split.to!(int[]), m = rd[0], s = rd[1];
    auto tags = readln.split;
    foreach (tag; tags) h[tag] += s;
  }

  auto r = h.byPair.array;
  r.multiSort!("a[1] > b[1]", "a[0] < b[0]");
  foreach (ri; r.take(10))
    writeln(ri[0], " ", ri[1]);
}
