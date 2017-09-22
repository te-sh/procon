import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto g = new bool[][](n, n);
  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), a = rd2[0]-1, b = rd2[1]-1;
    g[a][b] = g[b][a] = true;
  }

  auto isValid(size_t[] p)
  {
    if (!g[0][p[0]]) return false;
    foreach (i; 0..n-2)
      if (!g[p[i]][p[i+1]]) return false;
    return true;
  }

  auto p = iota(1, n).array, ans = 0;
  do {
    if (isValid(p)) ++ans;
  } while (p.nextPermutation);

  writeln(ans);
}
