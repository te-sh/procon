import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.bigint;    // BigInt
import std.regex;     // Regex

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

const inf = BigInt(1L<<62);

version(unittest) {} else
void main()
{
  auto s = readArray!long(26);
  string t; readV(t);

  auto y = new int[][](26);
  foreach (i; 0..26) {
    auto c = cast(char)('a'+i);
    y[i] = t.matchAll(regex(c.to!string ~ '+')).map!((m) => m[0].length.to!int).array;
    if (s[i] < y[i].sum) {
      writeln(0);
      return;
    }
  }

  auto d = BigInt(1);
  foreach (i, si; s) {
    d = calc(BigInt(si), t, y[i], d);
    if (d >= inf) {
      writeln("hel");
      return;
    }
  }

  writeln(d);
}

auto calc(BigInt s, string t, int[] y, BigInt d)
{
  auto ny = y.length.to!int;
  if (y.empty) return d;

  if (s > 10^^7) {
    if (ny == 1) {
      if (y[0] == 1) return d*s;
      if (y[0] == 2) return d*s*(s-1)/2;
    } else if (ny == 2) {
      if (y[0] == 1 && y[1] == 1) return d*s/2*(s-s/2);
    }
    return inf;
  }

  auto r = new Rat[](ny);
  foreach (i, yi; y)
    r[i] = Rat(yi+1, yi);

  auto h = heapify(r);
  foreach (i; 0..(s-y.sum).to!int) {
    auto ri = h.front;
    d = d * ri.n / (ri.n-ri.r);
    if (d >= inf) return inf;
    h.replaceFront(Rat(ri.n+1, ri.r));
  }

  return d;
}

struct Rat
{
  long n, r;

  auto opCmp(Rat b)
  {
    auto num = n, den = n-r, bnum = b.n, bden = b.n-b.r;
    auto c = num*bden - den*bnum;
    return c == 0 ? 0 : c < 0 ? -1 : 1;
  }
}
