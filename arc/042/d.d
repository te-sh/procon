import std.algorithm, std.conv, std.range, std.stdio, std.string;

void read4(S,T,U,V)(ref S a,ref T b,ref U c,ref V d){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;r.popFront;c=r.front.to!U;r.popFront;d=r.front.to!V;r.popFront;}

version(unittest) {} else
void main()
{
  auto t = (1<<24);
  long x, p, a, b; read4(x, p, a, b);

  if (a%(p-1) == 0 || a/(p-1) < b/(p-1)) {
    writeln(1);
    return;
  }

  a %= p-1; b %= p-1;

  if (b-a < t) {
    auto r = repeatedSquare!(long, (a, b) => a*b%p, long)(x, a), ans = r;
    foreach (i; 0..b-a) {
      (r *= x) %= p;
      ans = min(ans, r);
    }
    writeln(ans);
  } else {
    foreach (k; 1..p) {
      auto i = bsgs(x, k, p);
      if (a <= i && i <= b) {
        writeln(k);
        return;
      }
    }
  }
}

auto bsgs(long x, long y, long m)
{
  import std.math;
  struct VI { long v, i; }

  if (y == 1) return 0;

  auto h = m.to!real.sqrt.ceil.to!long;

  auto bs = new VI[](h);
  bs[0] = VI(y, 0);
  foreach (j; 1..h) bs[j] = VI(bs[j-1].v*x%m, j);
  auto bss = bs.sort!"a.v < b.v";

  auto xh = repeatedSquare!(long, (a, b) => a*b%m)(x, h), r = 1L;
  foreach (i; 0..h) {
    (r *= xh) %= m;
    auto s = bss.equalRange(VI(r, 0));
    if (!s.empty) return (i+1)*h-s.front.i;
  }

  return -1;
}

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n)
{
  return repeatedSquare!(T, pred, U)(a, n, T(1));
}

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}
