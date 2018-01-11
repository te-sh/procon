struct Matrix(T)
{
  size_t r, c;
  T[][] a;

  static ref auto unit(size_t n)
  {
    auto r = Matrix!T(n, n);
    foreach (i; 0..n) r[i][i] = 1;
    return r;
  }

  this(size_t r, size_t c)
  {
    this.r = r; this.c = c;
    a = new T[][](r, c);
    static if (T.init != 0) foreach (i; 0..r) a[i][] = 0;
  }

  ref T[] opIndex(size_t i) { return a[i]; }

  ref auto opBinary(string op)(ref Matrix!T b) if (op == "+" || op == "-") in { assert(r == b.r && c == b.c); } body
  {
    auto x = Matrix!T(r, c);
    foreach (i; 0..r) foreach (j; 0..c) x[i][j] = mixin("a[i][j]"~op~"b[i][j]");
    return x;
  }

  ref auto opBinary(string op: "*")(ref Matrix!T b) in { assert(c == b.r); } body
  {
    auto x = Matrix!T(r, b.c);
    foreach (i; 0..r) foreach (j; 0..b.c) foreach (k; 0..c) x[i][j] += a[i][k]*b[k][j];
    return x;
  }
}

unittest
{
  auto u = Matrix!int.unit(2);
  assert(u[0] == [1, 0] && u[1] == [0, 1]);

  auto a = Matrix!int(2, 2);
  a[0] = [1, -1]; a[1] = [-2, 3];
  auto b = Matrix!int(2, 2);
  b[0] = [1, 2]; b[1] = [3, 4];

  auto c1 = a + b;
  assert(c1[0] == [2, 1] && c1[1] == [1, 7]);

  auto c2 = a - b;
  assert(c2[0] == [0, -3] && c2[1] == [-5, -1]);

  auto c3 = a * b;
  assert(c3[0] == [-2, -2] && c3[1] == [7, 8]);
}
