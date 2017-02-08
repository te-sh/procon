import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias Point!int point;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];
  auto sij = h.iota.map!(_ => readln.chomp).array;

  auto s = {
    foreach (y; 0..h)
      foreach (x; 0..w)
        if (sij[y][x] == '#') return point(x, y);
    return point(-1, -1);
  }();

  if (s == point(-1, -1)) {
    writeln("NO");
    return;
  }

  auto canPaint(int x, int y) {
    auto d = point(x, y) - s;
    auto tij = new bool[][](h, w);
    tij[s.y][s.x] = tij[y][x] = true;
    foreach (iy; 0..h)
      foreach (ix; 0..w)
        if (sij[iy][ix] == '#' && !tij[iy][ix]) {
          auto ip = d + point(ix, iy);
          if (ip.x < 0 || ip.x >= w || ip.y >= h || sij[ip.y][ip.x] != '#' || tij[ip.y][ip.x])
            return false;
          tij[iy][ix] = tij[ip.y][ip.x] = true;
        }
    return true;
  }

  auto r = {
    foreach (y; s.y..h)
      foreach (x; 0..w)
        if (s != point(x, y) && sij[y][x] == '#' && canPaint(x, y))
          return true;
    return false;
  }();

  writeln(r ? "YES" : "NO");
}

struct Point(T) {
  T x, y;

  auto opBinary(string op: "+")(Point!T rhs) { return Point!T(x + rhs.x, y + rhs.y); }
  auto opBinary(string op: "-")(Point!T rhs) { return Point!T(x - rhs.x, y - rhs.y); }
  auto opBinary(string op: "*")(Point!T rhs) { return x * rhs.x + y * rhs.y; }
  auto opBinary(string op: "*")(T a) { return Point!T(x * a, y * a); }

  T hypot2() { return x ^^ 2 + y ^^ 2; }
}
