import std.algorithm, std.conv, std.range, std.stdio, std.string;
import core.bitop;    // bit operation

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);
  ai.sort();

  int calc(int[] ai) {
    if (ai.empty) return int.max;
    if (ai.back == 0) return 0;
    auto i = ai.back.bsr, bi = ai.assumeSorted;
    auto ci = bi.lowerBound(1 << i).array;
    auto di = bi.upperBound((1 << i) - 1).map!(a => a.bitReset(i)).array;
    auto c = calc(ci);
    if (!di.empty) c = c.bitSet(i);
    auto d = calc(di);
    if (!ci.empty) d = d.bitSet(i);
    return min(c, d);
  }

  writeln(calc(ai));
}

T bitSet(T)(T n, size_t i) { return n | (1 << i); }
T bitReset(T)(T n, size_t i) { return n & ~(1 << i); }
int bsr(T)(T n) { return core.bitop.bsr(n.to!ulong); }
