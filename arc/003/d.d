import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.random;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1], k = rd1[2];
  auto pt = new int[](n);
  foreach (_1; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), a = rd2[0], b = rd2[1];
    pt[a] = pt[a].bitSet(b);
    pt[b] = pt[b].bitSet(a);
  }

  auto rep = 10 ^^ 6, s = 0;
 loop: foreach (_2; 0..rep) {
    auto t = iota(0, n).array;
    foreach (_3; 0..k) {
      size_t a = uniform(0, n);
      size_t b = uniform(0, n-1);
      if (b >= a) ++b;
      swap(t[a], t[b]);
    }
    foreach (i; 0..n-1)
      if (pt[t[i]].bitTest(t[i+1])) continue loop;
    if (pt[t[n-1]].bitTest(t[0])) continue loop;
    ++s;
  }

  writefln("%.4f", s.to!real / rep);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }
}
