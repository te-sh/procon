import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1], n = rd[2];

  auto b = new int[](w);
  foreach (i; 0..h) {
    auto s = readln.chomp;
    foreach (j; 0..w)
      if (s[j] == '#' && !b[j])
        b[j] = h-i;
  }

  struct Pack { int i, c; int[] b; }
  auto packs = new Pack[](n);
  foreach (i; 0..n) {
    auto c = readln.chomp.to!int;
    packs[i] = Pack(i, c, new int[](3));
  }

  packs.sort!"a.c < b.c";

  auto bi = 0, bj = 0;
  foreach (i; 0..w) {
    while (bi < n && packs[bi].c < i-2) ++bi;
    while (bj < n && packs[bj].c <= i) ++bj;
    if (b[i] < bj-bi) {
      auto r = b[i];
      foreach (bk; bi..bj) {
        if (r == 0)
          break;
        if (packs[bk].b[0..i-packs[bk].c].sum == 0) {
          ++packs[bk].b[i-packs[bk].c];
          --r;
        }
      }
      foreach (bk; bi..bi+r)
        ++packs[bk].b[i-packs[bk].c];
    } else {
      foreach (bk; bi..bj)
        packs[bk].b[i-packs[bk].c] = b[i]/(bj-bi) + (bk-bi < b[i]%(bj-bi));
    }
  }

  packs.sort!"a.i < b.i";

  foreach (pack; packs)
    foreach (i; 0..3) {
      foreach (j; 0..3)
        write(pack.b[j] > i ? "#" : ".");
      writeln;
    }
}
