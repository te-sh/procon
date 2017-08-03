import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias Point!int point;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  if (n == 1) {
    writeln("possible");
    writeln(1);
    return;
  } else if (n == 2) {
    writeln("impossible");
    return;
  }

  auto a = n.iota.map!(_ => readln.split.to!(int[])).array;
  auto r = calc(n);

  auto aep = a.findK(0), rep = r.findK(n * n), dp = aep - rep;
  auto ds = (dp.x + dp.y).abs % 2;

  a[aep.y][aep.x] = n * n;

  auto aiv = a.calcInv, riv = r.calcInv;
  auto ivs = (aiv - riv).abs % 2;

  if (ds != ivs) {
    if (n % 2 == 1)
      foreach (i; 0..n) swap(r[i][0], r[i][$-1]);
    else
      foreach (i; 0..n) r[i].reverse();
  }

  writeln("possible");
  foreach (i; 0..n) {
    foreach (j; 0..n) {
      write(r[i][j]);
      if (j < n-1) write(" ");
    }
    writeln;
  }
}

auto findK(int[][] a, int k)
{
  auto n = a.length.to!int;

  foreach (r; 0..n)
    foreach (c; 0..n)
      if (a[r][c] == k)
        return point(c, r);

  assert(0);
}

auto calcInv(int[][] a)
{
  auto n = a.length, bt = BiTree!int(n * n), inv = 0;

  foreach_reverse (r; 0..n)
    foreach_reverse (c; 0..n) {
      inv += bt[0..a[r][c]];
      bt[a[r][c]] += 1;
    }

  return inv;
}

auto calc(int n)
{
  if (n % 2 == 1) {
    return calc1(n);
  } else if (n % 4 == 0) {
    return calc2(n);
  } else {
    return calc3(n);
  }
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

struct Point(T)
{
  T x, y;
  pure auto opBinary(string op: "+")(Point!T rhs) const { return Point!T(x + rhs.x, y + rhs.y); }
  pure auto opBinary(string op: "-")(Point!T rhs) const { return Point!T(x - rhs.x, y - rhs.y); }
  pure auto opBinary(string op: "*")(Point!T rhs) const { return x * rhs.x + y * rhs.y; }
  pure auto opBinary(string op: "*")(T a) const { return Point!T(x * a, y * a); }
  pure auto opBinary(string op: "/")(T a) const { return Point!T(x / a, y / a); }
  pure auto hypot2() const { return x ^^ 2 + y ^^ 2; }
}

struct BiTree(T)
{
  const size_t n;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    this.buf = new T[](n + 1);
  }

  void opIndexOpAssign(string op: "+")(T val, size_t i)
  {
    ++i;
    for (; i <= n; i += i & -i)
      buf[i] += val;
  }

  pure T opSlice(size_t r, size_t l) const
  {
    return get(l) - get(r);
  }

  pure size_t opDollar() const { return n; }
  pure T opIndex(size_t i) const { return opSlice(i, i+1); }

private:

  pure T get(size_t i) const
  {
    auto s = T(0);
    for (; i > 0; i -= i & -i)
      s += buf[i];
    return s;
  }
}
