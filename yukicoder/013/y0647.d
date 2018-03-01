import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  struct Ps { int a, b; }
  int n; readV(n);
  auto ps = new Ps[](n);
  foreach (i; 0..n) {
    int a, b; readV(a, b);
    ps[i] = Ps(a, b);
  }

  struct Mt { int i, c; }
  int m; readV(m);
  auto mt = new Mt[](m);
  foreach (i; 0..m) {
    int x, y; readV(x, y);
    mt[i] = Mt(i+1, ps.count!((psi) => x <= psi.a && y >= psi.b).to!int);
  }

  mt.sort!"a.c == b.c ? a.i < b.i : a.c > b.c";
  if (mt[0].c == 0) {
    writeln(0);
  } else {
    auto mc = mt[0].c;
    foreach (mti; mt) {
      if (mti.c < mc) break;
      writeln(mti.i);
    }
  }
}
