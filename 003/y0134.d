import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), s = point(rd1[0], rd1[1]);
  auto n = readln.chomp.to!size_t;
  auto pi = new point[](n), wi = new real[](n);
  foreach (i; n.iota) {
    auto rd2 = readln.split;
    pi[i] = point(rd2[0].to!int, rd2[1].to!int);
    wi[i] = rd2[2].to!real;
  }

  auto vi = new real[](1 << n);
  foreach (i; (1 << n).iota)
    vi[i] = wi.indexed(i.bitsSet).sum;

  auto dp = new real[][](1 << n, n);
  foreach (j; n.iota) {
    dp[0][j] = real(100) / 120 * manDis(pi[j], s) + wi[j];
  }

  foreach (i; ((1 << n) - 1).iota) {
    foreach (j; n.iota) {
      foreach (k; n.iota) {
        if (j == k || i.bitTest(j)) continue;
        auto ni = i.bitSet(j);
        auto nv = dp[i][j] + (vi[ni] + 100) / 120 * manDis(pi[k], pi[j]) + wi[k];
        if (dp[ni][k].isNaN)
          dp[ni][k] = nv;
        else
          dp[ni][k] = min(dp[ni][k], nv);
      }
    }
  }

  auto f = (1 << n) - 1;
  auto mi = real.max;
  foreach (i; n.iota) {
    auto ni = f.bitReset(i);
    auto nv = dp[ni][i] + (vi[f] + 100) / 120 * manDis(pi[i], s);
    mi = min(mi, nv);
  }

  writefln("%.8f", mi);
}

auto manDis(point p1, point p2)
{
  return (p1.x - p2.x).abs + (p1.y - p2.y).abs;
}

template BitOp(T) {
  bool bitTest(T n, size_t i) { return (n & (1.to!T << i)) != 0; }
  T bitSet(T n, size_t i) { return n | (1.to!T << i); }
  T bitReset(T n, size_t i) { return n & ~(1.to!T << i); }
}

mixin BitOp!int;

struct Point(T) {
  T x, y;
}

alias Point!int point;
