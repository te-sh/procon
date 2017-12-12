import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];

  auto g = new bool[][](n, n);
  foreach (i; 0..m) {
    auto rd2 = readln.split.to!(int[]), a = rd2[0], b = rd2[1];
    g[a][b] = g[b][a] = true;
  }

  auto isSquare(int[] e)
  {
    do {
      if (g[e[0]][e[1]] && g[e[1]][e[2]] && g[e[2]][e[3]] && g[e[3]][e[0]] &&
          !g[e[0]][e[2]] && !g[e[1]][e[3]])
        return true;
    } while (e.nextPermutation);
    return false;
  }

  auto ans = 0;
  foreach (e1; 0..n)
    foreach (e2; e1+1..n)
      foreach (e3; e2+1..n)
        foreach (e4; e3+1..n)
          ans += isSquare([e1,e2,e3,e4]);

  writeln(ans);
}
