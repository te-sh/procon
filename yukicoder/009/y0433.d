import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1];

  struct Score { size_t i; int s, p, u; size_t ui; }
  auto scores = new Score*[](n);

  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto s = rd2.front.to!int; rd2.popFront();
    auto p = rd2.front.to!int; rd2.popFront();
    auto u = rd2.front.to!int;
    scores[i] = new Score(i, s, p, u);
  }

  scores.multiSort!("a.u < b.u", "a.s > b.s", "a.p < b.p");
  foreach (g; scores.chunkBy!"a.u == b.u")
    foreach (i, gi; g.enumerate)
      gi.ui = i;

  scores.multiSort!("a.s > b.s", "a.ui < b.ui", "a.p < b.p");

  foreach (i; 0..k)
    writeln(scores[i].i);
}
