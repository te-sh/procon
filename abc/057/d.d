import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], a = rd[1], b = rd[2];
  auto v = readln.split.to!(long[]);

  v.sort!"a > b";

  auto vs = v[0..a];
  writefln("%.7f", vs.sum.to!real / a);

  auto i = 0;
  while (a-1-i >= 0 && v[a-1] == v[a-1-i]) ++i;

  auto j = 0;
  while (a-1+j <  n && v[a-1] == v[a-1+j]) ++j;

  auto pt = pascalTriangle!long(n);
  if (v[a-1] != v[0]) {
    writeln(pt[i+j-1][i]);
  } else {
    auto ans = 0L;
    foreach (k; 0..min(b-a+1,j)) ans += pt[i+j-1][i+k];
    writeln(ans);
  }
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
