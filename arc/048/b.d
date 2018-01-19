import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);
  struct RH { int r, h, i; }
  auto rh = new RH[](n);
  foreach (i; 0..n) {
    int r, h; readV(r, h); --h;
    rh[i] = RH(r, h, i);
  }

  auto bs = rh.sort!"a.r == b.r ? a.h < b.h : a.r < b.r";

  struct RST { int w, l, d, i; }
  auto rst = new RST[](n);
  foreach (rhi; rh) {
    auto r = rhi.r, h = rhi.h, i = rhi.i;
    auto w = bs.lowerBound(RH(r, 0)).length.to!int;
    auto l = bs.upperBound(RH(r, 2)).length.to!int;

    auto hh = new int[](3);
    foreach (j; 0..3) hh[j] = bs.equalRange(RH(r, j)).length.to!int;

    auto d = hh[h]-1;
    w += hh[(h+1)%3];
    l += hh[(h+2)%3];

    rst[i] = RST(w, l, d, i);
  }

  rst.sort!"a.i < b.i";

  foreach (rsti; rst) writeln(rsti.w, " ", rsti.l, " ", rsti.d);
}
