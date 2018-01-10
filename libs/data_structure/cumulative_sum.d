struct CumulativeSum(T)
{
  size_t n;
  T[] s;

  this(T[] a)
  {
    n = a.length;
    s = new T[](n+1);
    s[0] = T(0);
    foreach (i; 0..n) s[i+1] = s[i] + a[i];
  }

  T opSlice(size_t l, size_t r) { return s[r]-s[l]; }
  size_t opDollar() { return n; }
}

auto cumulativeSum(T)(T[] a) { return CumulativeSum!T(a); }

unittest
{
  auto a = [1, 2, 3, 4, 5];
  auto cs = cumulativeSum(a);
  assert(cs[0..1] == 1);
  assert(cs[0..3] == 6);
  assert(cs[1..3] == 5);
  assert(cs[2..$] == 12);
}
