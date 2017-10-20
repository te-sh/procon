import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto x = new string[](n+1);
  x[0] = ".........";
  foreach (i; 0..n) x[i+1] = readln.chomp;

  auto ans = 0;
  foreach (i; 1..n+1)
    foreach (j; 0..9)
      if (x[i][j] == 'x' || x[i][j] == 'o' && x[i-1][j] != 'o')
        ++ans;

  writeln(ans);
}
