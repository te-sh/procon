import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto g = new int[][](n);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int; rd2.popFront();
    auto b = rd2.front.to!int;
    g[a] ~= b;
    g[b] ~= a;
  }

  auto b = new bool[](n);
  foreach_reverse (i; 0..n)
    if (!b[i])
      foreach (e; g[i])
        if (e < i)
          b[e] = true;

  b.reverse();

  foreach (bi; b[b.countUntil(true)..$])
    write(bi ? 1 : 0);
  writeln;
}
