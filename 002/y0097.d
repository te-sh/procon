import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], qn = rd[1];
  auto ai = generateA(n);

  if (n < 3000) {
    calc1(ai, qn);
  } else {
    calc2(ai, qn);
  }
}

void calc1(long[] ai, int qn)
{
  foreach (_; 0..qn) {
    auto q = readln.chomp.to!long;
    writeln(ai.map!(a => a * q % p).maxElement);
  }
}

void calc2(long[] ai, int qn)
{
  auto bi = new bool[](p);
  foreach (a; ai) bi[a] = true;

  foreach (_; 0..qn) {
    auto q = readln.chomp.to!long;

    if (q == 0) {
      writeln(0);
    } else {
      long qi, d;
      exEuclid(q, p, qi, d);
      foreach_reverse (m; 0..p) {
        auto i = ((m * qi) % p + p) % p;
        if (bi[i]) {
          writeln(m);
          break;
        }
      }
    }
  }
}

const p = 100003;

uint x = 123456789, y = 362436069, z = 521288629, w = 88675123;
uint xor128()
{
  uint t = x ^ (x << 11);
  x = y; y = z; z = w;
  return w = w ^ (w >> 19) ^ (t ^ (t >> 8));
}

long[] generateA(int n)
{
  auto ai = new long[](n);
  foreach (i, ref a; ai)
    a = xor128 % p;
  return ai;
}

pure T exEuclid(T)(T a, T b, ref T x, ref T y)
{
  auto g = a;
  x = 1;
  y = 0;
  if (b != 0) {
    g = exEuclid(b, a % b, y, x);
    y -= a / b * x;
  }
  return g;
}
