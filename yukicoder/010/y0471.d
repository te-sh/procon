import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias point = Point!int;

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!int;
  auto p = new point[](m);
  foreach (i; 0..m) {
    auto rd = readln.splitter;
    auto x = rd.front.to!int; rd.popFront();
    auto y = rd.front.to!int;
    p[i] = point(x, y);
  }

  auto q1 = ask(point(0, 0));
  auto q2 = ask(point(1, 0)) - q1;

  writeln("!");
  foreach (pi; p) {
    point r;
    if (q2.x == 1)
      r = point(pi.x, pi.y);
    else if (q2.x == -1)
      r = point(-pi.x, -pi.y);
    else if (q2.y == 1)
      r = point(-pi.y, pi.x);
    else if (q2.y == -1)
      r = point(pi.y, -pi.x);

    r = r + q1;

    writeln(r.x, " ", r.y);
  }
}

auto ask(point p)
{
  writeln("? ", p.x, " ", p.y); stdout.flush();
  auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1];
  return point(x, y);
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
