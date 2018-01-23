import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);
  foreach (_; 0..n) writeln(calc ? "YES" : "NO");
}

struct Rg
{
  real a, b;
  static empty() { return Rg(real.nan, real.nan); }
  auto isEmpty() { return a.isNaN; }
  auto opBinary(string op: "&")(Rg r)
  {
    if (isEmpty || r.isEmpty) return Rg.empty;
    auto s = Rg(max(a, r.a), min(b, r.b));
    return s.a >= s.b ? Rg.empty : s;
  }
}

auto calc()
{
  int x1, x2, x3, y1, y2, y3; readV(x1, x2, x3, y1, y2, y3);

  if (x1 == x3 && y1 == y3) return false;

  Rg r1, r2;
  if (y1 == y2) {
    r1 = x2 > x1 ? Rg(-real.infinity, real.infinity) : Rg.empty;
    r2 = x2 < x1 ? Rg(-real.infinity, real.infinity) : Rg.empty;
  } else {
    auto t = -(x1-x2).to!real/(y1-y2);
    r1 = y1 > y2 ? Rg(-real.infinity, t) : Rg(t, real.infinity);
    r2 = y1 > y2 ? Rg(t, real.infinity) : Rg(-real.infinity, t);
  }

  Rg r3, r4;
  if (y3 == y2) {
    r3 = x2 > x3 ? Rg(-real.infinity, real.infinity) : Rg.empty;
    r4 = x2 < x3 ? Rg(-real.infinity, real.infinity) : Rg.empty;
  } else {
    auto t = -(x3-x2).to!real/(y3-y2);
    r3 = y3 > y2 ? Rg(-real.infinity, t) : Rg(t, real.infinity);
    r4 = y3 > y2 ? Rg(t, real.infinity) : Rg(-real.infinity, t);
  }

  auto s1 = r1 & r3, s2 = r2 & r4;
  return !s1.isEmpty && s1.b > 0 || !s2.isEmpty && s2.b > 0;
}
