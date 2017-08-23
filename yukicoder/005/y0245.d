import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias Point!int point;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto pi = new point[](n*2);
  foreach (i; 0..n) {
    auto rd = readln.split.to!(int[]);
    pi[i*2] = point(rd[0], rd[1]);
    pi[i*2+1] = point(rd[2], rd[3]);
  }

  auto maxR = 0;
  foreach (i; 0..n*2)
    foreach (j; i+1..n*2) {
      auto p1 = pi[i], p2 = pi[j], pa = p2 - p1;
      if (p1 == p2) continue;
      auto r = 0;
      foreach (k; 0..n) {
        auto p3 = pi[k*2], p4 = pi[k*2+1];
        if (cross(pa, p3 - p1) * cross(pa, p4 - p1) <= 0)
          ++r;
      }
      maxR = max(maxR, r);
    }

  writeln(maxR);
}

auto cross(point p1, point p2)
{
  return p1.x * p2.y - p1.y * p2.x;
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
