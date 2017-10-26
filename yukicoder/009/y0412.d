import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.split.to!(int[]), ns = s.length;
  auto n = readln.chomp.to!size_t;
  auto e = readln.split.to!(int[]);

  s.sort();
  auto b = s[0], c = s[1], d = s[2];

  auto s1 = e.count!(ei => b <= ei && ei < c);
  auto s2 = e.count!(ei => c <= ei && ei < d);
  auto s3 = e.count!(ei => d <= ei);

  auto pt = pascalTriangle!int(n), ans = 0;

  foreach (i1; 0..s1+1)
    foreach (i2; 0..s2+1)
      foreach (i3; 0..s3+1) {
        if (i3 >= 3 ||
            i3 == 2 && (i2 >= 1 || i1 >= 1) ||
            i3 == 1 && (i2 >= 2 || i2 == 1 && i1 >= 1)) {
          ans += pt[s3][i3] * pt[s2][i2] * pt[s1][i1] * 2 ^^ (n-s1-s2-s3);
        }
      }

  writeln(ans);
}

pure T[][] pascalTriangle(T)(size_t n)
{
  auto t = new T[][](n + 1);
  t[0] = new T[](1);
  t[0][0] = 1;
  foreach (i; 1..n+1) {
    t[i] = new T[](i + 1);
    t[i][0] = t[i][$-1] = 1;
    foreach (j; 1..i)
      t[i][j] = t[i - 1][j - 1] + t[i - 1][j];
  }
  return t;
}
