struct Point(T)
{
  T x, y;
  pure auto opBinary(string op)(Point!T r) if (op == "+" || op == "-") { return mixin("Point!T(x"~op~"r.x,y"~op~"r.y)"); }
  pure auto opBinary(string op)(T a) if (op == "*" || op == "/") { return mixin("Point!T(x"~op~"a,y"~op~"a)"); }
  auto opOpAssign(string op)(Point!T r) if (op == "+" || op == "-") { mixin("x"~op~"=r.x; y"~op~"=r.y;"); return this; }
  auto opOpAssign(string op)(T a) if (op == "*" || op == "/") { mixin("x"~op~"=a; y"~op~"=a;"); return this; }
  pure auto opBinary(string op: "*")(Point!T r) { return x*r.x + y*r.y; }
  pure auto hypot2() const { return x^^2 + y^^2; }
}

struct Point3(T)
{
  T x, y, z;
  pure auto opBinary(string op)(Point3!T r) if (op == "+" || op == "-") { return mixin("Point3!T(x"~op~"r.x,y"~op~"r.y,z"~op~"r.z)"); }
  pure auto opBinary(string op)(T a) if (op == "*" || op == "/") { return mixin("Point3!T(x"~op~"a,y"~op~"a,z"~op~"a)"); }
  auto opOpAssign(string op)(Point3!T r) if (op == "+" || op == "-") { mixin("x"~op~"=r.x; y"~op~"=r.y; z"~op~"=r.z;"); return this; }
  auto opOpAssign(string op)(T a) if (op == "*" || op == "/") { mixin("x"~op~"=a; y"~op~"=a; z"~op~"=a;"); return this; }
  pure auto opBinary(string op: "*")(Point3!T r) { return x*r.x + y*r.y + z*r.z; }
  pure auto hypot2() const { return x^^2 + y^^2 + z^^2; }
}

pure auto outerProd(T)(Point3!T p1, Point3!T p2)
{
  return Point3!T(p1.y*p2.z - p1.z*p2.y, p1.z*p2.x - p1.x*p2.z, p1.x*p2.y - p1.y*p2.x);
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

  p1 += p2;
  assert(p1 == point(3, 7));
  p1 -= p2;
  assert(p1 == point(2, 4));
  p1 *= 2;
  assert(p1 == point(4, 8));
  p1 /= 2;
  assert(p1 == point(2, 4));
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

  p1 += p2;
  assert(p1 == point3(3, 7, 7));
  p1 -= p2;
  assert(p1 == point3(2, 4, 5));
  p1 *= 2;
  assert(p1 == point3(4, 8, 10));
  p1 /= 2;
  assert(p1 == point3(2, 4, 5));
}
