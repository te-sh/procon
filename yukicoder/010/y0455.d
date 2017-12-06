import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];
  auto s = new char[][](h);
  foreach (i; 0..h) s[i] = readln.chomp.dup;

  int x1 = -1, y1 = -1, x2 = -1, y2 = -1;
  foreach (i; 0..h)
    foreach (j; 0..w)
      if (s[i][j] == '*') {
        if (x1 < 0 && y1 < 0) {
          x1 = j;
          y1 = i;
        } else {
          x2 = j;
          y2 = i;
        }
      }

  auto onLine(int x3, int y3)
  {
    auto x12 = x2 - x1, y12 = y2 - y1;
    auto x13 = x3 - x1, y13 = y3 - y1;
    return x12 * y13 - x13 * y12 == 0;
  }

 loop: foreach (i; 0..h)
    foreach (j; 0..w) {
      if (s[i][j] == '*') continue;
      if (!onLine(j, i)) {
        s[i][j] = '*';
        break loop;
      }
    }

  foreach (i; 0..h)
    writeln(s[i]);
}
