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

unittest
{
  assert(bitTest(2, 1));
  assert(!bitTest(2, 2));
  assert(bitSet(4, 1) == 6);
  assert(bitSet(6, 1) == 6);
  assert(bitSet(8, 1, 2) == 10);
  assert(bitSet(8, 1, 4) == 14);
  assert(bitReset(4, 1) == 4);
  assert(bitReset(6, 1) == 4);
  assert(bitReset(10, 1, 3) == 8);
  assert(bitReset(14, 1, 3) == 8);
  assert(bitComp(4, 1) == 6);
  assert(bitComp(6, 1) == 4);
  assert(bitComp(10, 1, 3) == 12);
  assert(bitComp(10, 1, 4) == 4);
  assert(bsf(6) == 1);
  assert(bsr(6) == 2);
  assert(popcnt(6) == 2);
}
