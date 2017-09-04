import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1];
  auto t = new int[][](n, k);
  foreach (i; 0..n) t[i] = readln.split.to!(int[]);

  bool foundBug(size_t i, int x)
  {
    if (i == n) return x == 0;

    foreach (j; 0..k)
      if (foundBug(i+1, x ^ t[i][j])) return true;

    return false;
  }

  writeln(foundBug(0, 0) ? "Found" : "Nothing");
}
