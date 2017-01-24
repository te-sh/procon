import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray
import std.container;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto di = readln.split.to!(int[]);
  auto wi = readln.split.to!(int[]).to!(bool[]);

  auto aij = new bool[][](n, n + 1);
  foreach (i; n.iota) {
    auto ii = i.to!int, ni = n.to!int;
    auto d1 = (ii + di[i]) % ni;
    auto d2 = ((ii - di[i]) % ni + ni) % ni;
    aij[d1][i] = aij[d2][i] = true;
    aij[i][n] = !wi[i];
  }

  gaussJordan(aij, n);
  writeln(hasSolution(aij, n) ? "Yes" : "No");
}

void gaussJordan(bool[][] aij, size_t n)
{
  size_t i, j;
  while (i < n && j < n) {
    if (!aij[i][j]) {
      auto k = aij[i+1..$].countUntil!(ai => ai[j]);
      if (k == -1)
        ++j;
      else
        swap(aij[i], aij[i + k + 1]);
    }

    if (aij[i][j]) {
      foreach (k, ref ai; aij[i+1..$])
        if (ai[j]) ai[] ^= aij[i][];
      ++i;
      ++j;
    }
  }
}

auto hasSolution(bool[][] aij, size_t n)
{
  foreach (ai; aij)
    if (ai[0..n].all!"!a" && ai[n]) return false;
  return true;
}
