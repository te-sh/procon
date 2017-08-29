import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias point = Point!int;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), w = rd[0], h = rd[1];

  auto n = readln.chomp.to!size_t;
  auto s = new point[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(int[]);
    s[i] = point(rd2[0]-1, rd2[1]-1);
  }

  long[point][point] memo;

  long calcMax(point lb, point tr, point[] s)
  {
    if (!hasGold(lb, tr)) return 0L;
    s = filterSouchi(lb, tr, s);

    if (lb in memo && tr in memo[lb]) return memo[lb][tr];

    auto ret = 0L;
    foreach (i, si; s) {
      auto r = (tr.x - lb.x) + (tr.y - lb.y) - 1;

      r += calcMax(lb, si, s);
      r += calcMax(point(lb.x, si.y+1), point(si.x, tr.y), s);
      r += calcMax(point(si.x+1, lb.y), point(tr.x, si.y), s);
      r += calcMax(point(si.x+1, si.y+1), tr, s);

      ret = max(ret, r);
    }

    return memo[lb][tr] = ret;
  }

  writeln(calcMax(point(0, 0), point(w, h), s));
}

auto hasGold(point lb, point tr)
{
  return lb.x < tr.x && lb.y < tr.y;
}

auto filterSouchi(point lb, point tr, point[] s)
{
  return s.filter!((si) => lb.x <= si.x && si.x < tr.x && lb.y <= si.y && si.y <= tr.y).array;
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
