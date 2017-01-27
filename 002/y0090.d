import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  auto score = new int[][](n, n);
  foreach (_; m.iota) {
    auto rd2 = readln.split.to!(int[]);
    score[rd2[0]][rd2[1]] = rd2[2];
  }

  auto calcScore(Range)(Range ai) {
    auto r = 0;
    foreach (i, a; ai.enumerate)
      foreach (b; ai[i+1..$])
        r += score[a][b];
    return r;
  }

  writeln(n.iota.permutations.map!(a => calcScore(a)).fold!max);
}
