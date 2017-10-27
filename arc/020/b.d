import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, c = rd[1].to!int;
  auto a = new int[](n);
  foreach (i; 0..n) a[i] = readln.chomp.to!int;

  auto a1 = new int[]((n+1)/2), a2 = new int[](n/2);
  foreach (i; 0..n)
    if (i % 2 == 0) a1[i/2] = a[i];
    else            a2[i/2] = a[i];

  auto ans = int.max;
  foreach (c1; 1..11)
    foreach (c2; 1..11) {
      if (c1 == c2) continue;
      auto r = 0;
      foreach (a1i; a1) if (a1i != c1) ++r;
      foreach (a2i; a2) if (a2i != c2) ++r;
      ans = min(ans, r);
    }

  writeln(ans*c);
}
