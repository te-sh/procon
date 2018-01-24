import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n, w; long h; readV(n, w, h);
  auto a = new int[](n), b = new int[](n), x = new int[](n);
  foreach (i; 0..n) {
    readV(a[i], b[i], x[i]); --x[i];
  }

  auto isExceed(int t, int[] c)
  {
    auto s = new long[](w+1);
    foreach (ai, bi, xi; lockstep(a[0..t], b[0..t], x[0..t])) {
      s[xi] += bi;
      s[xi+ai] -= bi;
    }
    foreach (i; 1..w) s[i] = s[i-1]+s[i];
    auto r = new bool[](c.length);
    foreach (i, ci; c) r[i] = s[ci] >= h;
    return r;
  }

  auto separateC(int[] c, bool[] r)
  {
    int[] f, t;
    foreach (ci, ri; lockstep(c, r)) {
      if (ri) t ~= ci;
      else    f ~= ci;
    }
    return tuple(f, t);
  }

  auto mergeC(int[] c1, int[] t1, int[] c2, int[] t2)
  {
    auto n1 = c1.length, n2 = c2.length;
    auto t = new int[](n1+n2), i = 0, i1 = 0, i2 = 0;
    while (i < n1+n2) {
      if (i1 >= n1)             t[i++] = t2[i2++];
      else if (i2 >= n2)        t[i++] = t1[i1++];
      else if (c1[i1] < c2[i2]) t[i++] = t1[i1++];
      else                      t[i++] = t2[i2++];
    }
    return t;
  }

  int[] bsearch(int mi, int ma, int[] c)
  {
    if (c.empty) return [];
    if (ma-mi <= 1) {
      auto r = isExceed(mi, c);
      auto t = new int[](c.length);
      foreach (ci, ref ti, ri; lockstep(c, t, r)) ti = ri ? mi : ma;
      return t;
    } else {
      auto ce = (mi+ma)/2, r = isExceed(ce, c);
      auto cs = separateC(c, r), c1 = cs[0], c2 = cs[1];
      auto t1 = bsearch(ce, ma, c1);
      auto t2 = bsearch(mi, ce, c2);
      return mergeC(c1, t1, c2, t2);
    }
  }

  auto t = bsearch(0, n, iota(0, w).array);

  auto p = new int[](2);
  foreach (ti; t) ++p[ti%2];

  writeln(p[0] == p[1] ? "DRAW" : p[0] < p[1] ? "A" : "B");
}
