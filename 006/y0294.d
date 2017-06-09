import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.format;

const comt = [0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 2, 2, 1, 2, 1, 1, 1, 3, 3, 3, 2, 3, 2, 2, 3, 6, 5, 5, 5, 5, 5, 5, 6, 11, 10, 10, 11, 10, 11, 11, 11, 21, 21, 21, 22, 21, 22, 22, 21, 42, 43, 43, 43, 43, 43, 43, 42, 85, 86, 86, 85, 86, 85, 85, 85, 171, 171, 171, 170, 171, 170, 170, 171, 342, 341, 341, 341, 341, 341, 341, 342, 683, 682, 682, 683, 682, 683, 683, 683, 1365, 1365, 1365, 1366, 1365, 1366, 1366, 1365, 2730, 2731, 2731, 2731, 2731, 2731, 2731, 2730, 5461, 5462, 5462, 5461, 5462, 5461, 5461, 5461, 10923, 10923, 10923, 10922, 10923, 10922, 10922, 10923, 21846, 21845, 21845, 21845, 21845, 21845, 21845, 21846, 43691, 43690, 43690, 43691, 43690, 43691, 43691, 43691, 87381, 87381, 87381, 87382, 87381, 87382, 87382, 87381, 174762, 174763, 174763, 174763, 174763, 174763, 174763, 174762, 349525, 349526, 349526, 349525, 349526, 349525, 349525, 349525, 699051, 699051, 699051, 699050, 699051, 699050, 699050, 699051];

const coms = comt.cumulativeFold!"a + b".array;

const bt = [0, 1, 1, 2, 1, 2, 2, 3];

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  if (n == 1) {
    writeln(555);
    return;
  }

  --n;

  auto a = coms.assumeSorted.lowerBound(n), al = a.length.to!int;
  auto b = al / 8, c = al % 8, m = n - a.back - 1;

  auto ct = 0;
  foreach (i; 0..(1 << b)) {
    if ((i.popcnt + bt[c] + 1) % 3 == 0) {
      if (ct++ == m) {
        writeln(toOutput(b, c, i));
        return;
      }
    }
  }
  writeln(ct);
}

auto toOutput(int b, int c, int i)
{
  auto t = b > 0 ? format("%0" ~ b.to!string ~ "b", i) : "";
  auto s = format("%03b", c) ~ t ~ '1';
  return s.tr(['0', '1'], ['3', '5']);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  pure T bitSet(T)(T n, size_t s, size_t e) { return n | ((T(1) << e) - 1) & ~((T(1) << s) - 1); }
  pure T bitReset(T)(T n, size_t s, size_t e) { return n & (~((T(1) << e) - 1) | ((T(1) << s) - 1)); }
  pure T bitComp(T)(T n, size_t s, size_t e) { return n ^ ((T(1) << e) - 1) & ~((T(1) << s) - 1); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
