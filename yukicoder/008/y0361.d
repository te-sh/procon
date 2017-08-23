import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), l = rd[0], d = rd[1];

  auto g = new int[](l+1);
  g[0..6][] = 0;

  foreach (i; 6..l+1) {
    auto mex = new bool[](l);
    foreach (l1; 1..i-1) {
      auto l2min = max(l1 + 1, i - l1 * 2 - d);
      auto l2max = (i - l1 + 1) / 2;
      foreach (l2; l2min..l2max) {
        auto l3 = i - l1 - l2;
        mex[g[l1] ^ g[l2] ^ g[l3]] = true;
      }
    }

    auto gi = mex.countUntil!"!a".to!int;
    g[i] = gi == -1 ? 0 : gi;
  }

  writeln(g[l] == 0 ? "matsu" : "kado");
}
