import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto d = readln.split.to!(int[]);
  d.sort();

  do {
    if (isIncreasingKadomatsu(d)) {
      writeln("YES");
      return;
    }
  } while (d.nextPermutation);

  writeln("NO");
}

auto isIncreasingKadomatsu(int[] d)
{
  foreach (i; 0..5)
    if (!isKadomatsu(d[i], d[i+1], d[i+2]) || d[i] > d[i+2])
      return false;

  return true;
}

auto isKadomatsu(int a, int b, int c)
{
  return a != b && b != c && c != a && (a > b && c > b || a < b && c < b);
}
