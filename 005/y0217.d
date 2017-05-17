import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  int[][] r;

  if (n % 2)
    r = calc1(n);
  else if ((n / 2) % 2 == 0)
    r = calc2(n);
  else
    r = calc3(n);

  foreach (ri; r)
    writeln(ri.to!(string[]).join(' '));
}

auto calc1(int n)
{
  auto r = new int[][](n, n);
  auto x = n/2, y = 0;
  foreach (i; 1..n^^2+1) {
    r[y][x] = i;

    auto nx = x + 1, ny = y - 1;
    if (nx >= n) nx = 0;
    if (ny < 0) ny = n-1;

    if (r[ny][nx]) {
      y += 1;
      if (y >= n) y = 0;
    } else {
      x = nx;
      y = ny;
    }
  }
  return r;
}

auto calc2(int n)
{
  auto r = new int[][](n, n);

  auto isTaikaku(int x, int y)
  {
    auto x4 = x % 4, y4 = y % 4;
    return ((x4 == 0 || x4 == 3) && (y4 == 0 || y4 == 3) ||
            (x4 == 1 || x4 == 2) && (y4 == 1 || y4 == 2));
  }

  foreach (y; 0..n)
    foreach (x; 0..n) {
      auto i = x + y * n + 1;
      if (isTaikaku(x, y))
        r[y][x] = i;
      else
        r[n-1-y][n-1-x] = i;
    }

  return r;
}

int[][] ml = [[4,1],[2,3]], mu = [[1,4],[2,3]], mx = [[1,4],[3,2]];

auto calc3(int n)
{
  auto m = n/2;

  auto s = calc1(m);
  foreach (ref si; s) { si[] -= 1; si[] *= 4; }

  auto t = new int[][][][](m, m);
  foreach (y; 0..m) {
    if (y <= m/2)        t[y][] = ml;
    else if (y == m/2+1) t[y][] = mu;
    else                 t[y][] = mx;
  }
  swap(t[m/2][m/2], t[m/2+1][m/2]);

  auto r = new int[][](n, n);
  foreach (y; 0..m)
    foreach (x; 0..m) {
      r[y*2][x*2]     = s[y][x] + t[y][x][0][0];
      r[y*2][x*2+1]   = s[y][x] + t[y][x][0][1];
      r[y*2+1][x*2]   = s[y][x] + t[y][x][1][0];
      r[y*2+1][x*2+1] = s[y][x] + t[y][x][1][1];
    }

  return r;
}
