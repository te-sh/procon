struct BiTree(T)
{
  const size_t n;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    this.buf = new T[](n+1);
  }

  void opIndexOpAssign(string op)(T val, size_t i) if (op == "+" || op == "-")
  {
    ++i;
    for (; i <= n; i += i & -i) mixin("buf[i] " ~ op ~ "= val;");
  }

  void opIndexUnary(string op)(size_t i) if (op == "++" || op == "--")
  {
    ++i;
    for (; i <= n; i += i & -i) mixin("buf[i]" ~ op ~ ";");
  }

  pure T opSlice(size_t r, size_t l) { return get(l) - get(r); }
  pure T opIndex(size_t i) { return opSlice(i, i+1); }
  pure size_t opDollar() { return n; }

private:

  pure T get(size_t i)
  {
    auto s = T(0);
    for (; i > 0; i -= i & -i) s += buf[i];
    return s;
  }
}

unittest
{
  auto bit = BiTree!int(15);

  assert(bit[0..2] == 0);
  assert(bit[0..3] == 0);
  assert(bit[0..6] == 0);
  assert(bit[5..$] == 0);

  bit[1] += 2;

  assert(bit[1] == 2);
  assert(bit[0..2] == 2);
  assert(bit[0..3] == 2);
  assert(bit[0..6] == 2);
  assert(bit[5..$] == 0);

  bit[2] += 3;
  bit[5] += 4;
  bit[10] -= 5;

  assert(bit[0..2] == 2);
  assert(bit[0..3] == 5);
  assert(bit[0..6] == 9);
  assert(bit[5..$] == -1);

  ++bit[10];

  assert(bit[5..$] == 0);
}
