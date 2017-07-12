import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1], c = rd[2];

  if (isKadomatsu(a, b, c)) {
    writeln("INF");
    return;
  }

  auto m = max(a, b, c), r = 0;
  foreach (p; 3..m+1)
    if (isKadomatsu(a % p, b % p, c % p)) ++r;

  writeln(r);
}

auto isKadomatsu(int a, int b, int c)
{
  return a != b && b != c && c != a && (a > b && c > b || a < b && c < b);
}
