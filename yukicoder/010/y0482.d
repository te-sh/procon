import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!int, k = rd[1].to!long;
  auto d = readln.split.map!(to!int).map!"a-1".array;

  auto v = new bool[](n), t = 0, r = 0;
  foreach (i; 0..n) {
    if (v[i]) continue;
    auto j = i;
    while (!v[j]) {
      v[j] = true;
      ++r;
      j = d[j];
    }
    t += r-1;
    r = 0;
  }

  writeln(k >= t && (k-t)%2 == 0 ? "YES" : "NO");
}
