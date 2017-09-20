import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias point = Point!int;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), h = rd1[0], w = rd1[1], n = rd1[2];
  auto p = new point[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int; rd2.popFront();
    auto b = rd2.front.to!int;
    p[i] = point(b, a);
  }

  p.multiSort!("a.y < b.y", "a.x < b.x");

  SortedRange!(point[], "a.x < b.x")[int] b;

  if (!p.empty) {
    auto prevI = 0, prevY = p[0].y;
    foreach (i; 0..n) {
      if (prevY != p[i].y) {
        b[prevY] = p[prevI..i].assumeSorted!"a.x < b.x";
        prevY = p[i].y;
        prevI = i;
      }
    }
    b[prevY] = p[prevI..$].assumeSorted!"a.x < b.x";
  }

  auto c = new long[](10);
  c[0] = (h-2).to!long * (w-2);

  foreach (pi; p) {
    auto dy = new long[][](3, 3);
    foreach (i; 0..3) {
      if (pi.y-2+i in b) {
        auto q = i < 2 ? b[pi.y-2+i] : b[pi.y].lowerBound(point(pi.x));
        foreach (j; 0..3)
          dy[i][j] = q.upperBound(point(pi.x-3+j, 0)).lowerBound(point(pi.x+j+1, 0)).length;
      }
    }
    foreach_reverse (i; 0..2) dy[i][] += dy[i+1][];

    foreach (i; 0..3)
      foreach (j; 0..3) {
        if (pi.y-2+i >= 1 && pi.y+i <= h && pi.x-2+j >= 1 && pi.x+j <= w) {
          --c[dy[i][j]];
          ++c[dy[i][j]+1];
        }
      }
  }

  foreach (ci; c) writeln(ci);
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
