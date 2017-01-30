import std.algorithm, std.conv, std.range, std.stdio, std.string;
import core.bitop;    // bit operation

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  int calc(size_t i, int[] ai) {
    if (ai.empty) return int.max;
    auto bi = ai.filter!(a => a.bitTest(i)).map!(a => a.bitReset(i)).array;
    auto ci = ai.filter!(a => !a.bitTest(i)).array;
    if (i == 0) return bi.empty || ci.empty ? 0 : 1;
    auto b = calc(i - 1, bi);
    if (!ci.empty) b = b.bitSet(i);
    auto c = calc(i - 1, ci);
    if (!bi.empty) c = c.bitSet(i);
    return min(b, c);
  }

  writeln(calc(ai.fold!max.bsr, ai));
}

bool bitTest(T)(T n, size_t i) { return (n & (1 << i)) != 0; }
T bitSet(T)(T n, size_t i) { return n | (1 << i); }
T bitReset(T)(T n, size_t i) { return n & ~(1 << i); }
int bsr(T)(T n) { return core.bitop.bsr(n.to!ulong); }
