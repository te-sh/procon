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

struct Point3(T)
{
  T x, y, z;
  pure auto opBinary(string op: "+")(Point3!T rhs) const { return Point3!T(x + rhs.x, y + rhs.y, z + rhs.z); }
  pure auto opBinary(string op: "-")(Point3!T rhs) const { return Point3!T(x - rhs.x, y - rhs.y, z - rhs.z); }
  pure auto opBinary(string op: "*")(Point3!T rhs) const { return x * rhs.x + y * rhs.y + z * rhs.z; }
  pure auto opBinary(string op: "*")(T a) const { return Point3!T(x * a, y * a, z * a); }
  pure auto opBinary(string op: "/")(T a) const { return Point3!T(x / a, y / a, z / a); }
  pure auto hypot2() const { return x ^^ 2 + y ^^ 2 + z ^^ 2; }
}

pure auto outerProd(T)(Point3!T p1, Point3!T p2)
{
  return Point3!T(p1.y * p2.z - p1.z * p2.y, p1.z * p2.x - p1.x * p2.z, p1.x * p2.y - p1.y * p2.x);
}

unittest
{
  alias Point!int point;
  auto p1 = point(2, 4);

  assert(p1.x == 2);
  assert(p1.y == 4);

  auto p2 = point(1, 3);

  assert(p1 + p2 == point(3, 7));
  assert(p1 - p2 == point(1, 1));
  assert(p1 * p2 == 14);
  assert(p1 * 2 == point(4, 8));
  assert(p1 / 3 == point(0, 1));

  assert(p1.hypot2 == 20);
}

unittest
{
  alias Point3!int point3;
  auto p1 = point3(2, 4, 5);

  assert(p1.x == 2);
  assert(p1.y == 4);
  assert(p1.z == 5);

  auto p2 = point3(1, 3, 2);

  assert(p1 + p2 == point3(3, 7, 7));
  assert(p1 - p2 == point3(1, 1, 3));
  assert(p1 * p2 == 24);
  assert(p1 * 2 == point3(4, 8, 10));
  assert(p1 / 2 == point3(1, 2, 2));

  assert(p1.hypot2 == 45);

  assert(outerProd(p1, p2) == point3(-7, 1, 2));
}
