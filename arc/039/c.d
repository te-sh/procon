import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias point = Point!int;

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!int;
  auto s = readln.chomp;

  auto p = point(0, 0);
  auto dirs = [point(-1, 0), point(1, 0), point(0, 1), point(0, -1)];

  point[][long] link;
  link[p.idx] = dirs.dup;

  foreach (c; s) {
    auto diri = c.predSwitch('L', 0, 'R', 1, 'U', 2, 'D', 3);
    auto np = link[p.idx][diri];

    link[np.idx] = new point[](4);

    foreach (i, dir; dirs) {
      auto np2 = np + dir;
      if (np2.idx in link)
        link[np.idx][i] = link[np2.idx][i];
      else
        link[np.idx][i] = np2;
    }

    foreach (i, dir; dirs) {
      auto rdiri = i.predSwitch(0, 1, 1, 0, 2, 3, 3, 2);
      auto np2 = link[np.idx][i] + dirs[rdiri];
      link[np2.idx][rdiri] = link[np.idx][rdiri];
    }

    link[p.idx][diri] = link[np.idx][diri];
    p = np;
  }

  writeln(p.x, " ", p.y);
}

auto idx(point p)
{
  return (p.x.to!long << 32) + p.y;
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
