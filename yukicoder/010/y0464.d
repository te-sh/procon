import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, n = s.length.to!int;

  auto t = new bool[][](n, n);
  foreach (i; 0..n) {
    t[i][i] = true;
    foreach (j; 1..min(i, n-i-1)+1) {
      if (s[i-j] != s[i+j]) break;
      t[i-j][i+j] = true;
    }
  }
  foreach (i; 0..n-1) {
    foreach (j; 1..min(i+1, n-i-1)+1) {
      if (s[i-j+1] != s[i+j]) break;
      t[i-j+1][i+j] = true;
    }
  }

  auto ans = 0L;
  foreach (i; 2..n-1) {
    auto r1 = 0L;
    foreach (j; 1..i)
      if (t[0][j-1] && t[j][i-1]) ++r1;

    auto r2 = 0L;
    foreach (j; 1..n-i)
      if (t[i+j][n-1]) ++r2;

    ans += r1 * r2;
  }

  writeln(ans);
}
