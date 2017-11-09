import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];
  auto c = new int[][](h, w);
  foreach (i; 0..h) c[i] = readln.split.to!(int[]);

  foreach (i; 0..h)
    foreach (j; 0..w)
      if ((i+j)%2) c[i][j] = -c[i][j];

  auto d = new int[][](h+1, w+1);
  foreach (i; 1..h+1)
    foreach (j; 1..w+1)
      d[i][j] = c[i-1][j-1] + d[i][j-1] + d[i-1][j] - d[i-1][j-1];

  auto ans = 0;
  foreach (i1; 1..h+1)
    foreach (i2; i1..h+1)
      foreach (j1; 1..w+1)
        foreach (j2; j1..w+1) {
          auto t = d[i2][j2] - d[i2][j1-1] - d[i1-1][j2] + d[i1-1][j1-1];
          if (t == 0)
            ans = max(ans, (i2-i1+1)*(j2-j1+1));
        }

  writeln(ans);
}
