import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = 31;
  auto x = readln.chomp.to!int;

  if (x == 0) {
    writeln(1, " ", 0);
    return;
  }

  if (x > n) {
    writeln(0, " ", 0);
    return;
  }

  auto pt = pascalTriangle!int(n);
  writeln(pt[n][x], " ", long((1<<n)-1) * pt[n-1][x-1]);
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
