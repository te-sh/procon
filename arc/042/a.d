import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];

  struct Th { int i; int lastUpdate; }
  auto th = new Th[](n);
  foreach (i; 0..n) th[i] = Th(i+1, -1);

  foreach (i; 0..m) {
    auto a = readln.chomp.to!int-1;
    th[a].lastUpdate = i;
  }

  th.multiSort!("a.lastUpdate > b.lastUpdate", "a.i < b.i");

  foreach (thi; th)
    writeln(thi.i);
}
