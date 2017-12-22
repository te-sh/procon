import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

alias point = Point3!BigInt;

void main()
{
  auto p = new point[](4);
  foreach (i; 0..4) {
    auto rd = readln.split.to!(BigInt[]), x = rd[0], y = rd[1], z = rd[2];
    p[i] = point(x, y, z);
  }

  foreach (i; 0..3) p[i] = p[i] - p[3];

  auto v = [outerProd(p[0], p[1]), outerProd(p[1], p[2]), outerProd(p[2], p[0])];
  auto u = outerProd(p[1]-p[0], p[2]-p[0]);

  auto ip = v.map!(vi => vi * u).array;
  writeln(ip.all!"a<0" || ip.all!"a>0" ? "YES" : "NO");
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
