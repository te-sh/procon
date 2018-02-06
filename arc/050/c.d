import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  long a, b; int m; readV(a, b, m);
  auto c = gcd(a, b);

  long calc(long i, long j)
  {
    if (j == 1) return 1;
    if (j % 2 == 0) {
      auto t = calc(i, j/2);
      return (t * 10L.repeatedSquare!((a, b) => a*b%m)(i*j/2) % m + t) % m;
    } else {
      return (calc(i, j-1) * 10L.repeatedSquare!((a, b) => a*b%m)(i) % m + 1) % m;
    }
  }

  writeln(calc(c, a/c) * calc(1, b) % m);
}

pure T repeatedSquare(alias pred = "a * b", T, U)(T a, U n)
{
  return repeatedSquare!(pred, T, U)(a, n, T(1));
}

pure T repeatedSquare(alias pred = "a * b", T, U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if (n&1) r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}
