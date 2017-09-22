import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];
  auto a = new string[](n), b = new string[](m);
  foreach (i; 0..n) a[i] = readln.chomp;
  foreach (i; 0..m) b[i] = readln.chomp;

  auto isSame(size_t i, size_t j)
  {
    foreach (k; 0..m)
      if (a[i+k][j..j+m] != b[k]) return false;
    return true;
  }

  foreach (i; 0..n-m+1)
    foreach (j; 0..n-m+1)
      if (isSame(i, j)) {
        writeln("Yes");
        return;
      }

  writeln("No");
}
