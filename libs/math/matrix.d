struct Matrix(T)
{
  size_t r, c;
  T[][] a;
  alias a this;

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

  this(T[][] b)
  {
    r = b.length;
    c = b[0].length;
    a = b;
  }

  ref auto dup() { auto x = Matrix!T(r, c); foreach (i; 0..r) x[i][] = a[i][]; return x; }

  ref auto opBinary(string op)(Matrix!T b) if (op == "+" || op == "-") in { assert(r == b.r && c == b.c); } body
  {
    auto x = Matrix!T(r, c);
    foreach (i; 0..r) foreach (j; 0..c) x[i][j] = mixin("a[i][j]"~op~"b[i][j]");
    return x;
  }

  ref auto opBinary(string op: "*")(Matrix!T b) in { assert(c == b.r); } body
  {
    auto x = Matrix!T(r, b.c);
    foreach (i; 0..r) foreach (j; 0..b.c) foreach (k; 0..c) x[i][j] += a[i][k]*b[k][j];
    return x;
  }

  ref auto opBinary(string op: "*")(T[] b) in { assert(c == b.length); } body
  {
    auto x = new T[](r);
    static if (T.init != 0) x[] = 0;
    foreach (i; 0..r) foreach (j; 0..c) x[i] += a[i][j]*b[j];
    return x;
  }
}

T det(T)(Matrix!T a) in { assert(a.r == a.c); } body
{
  import std.algorithm, std.math;

  auto n = a.r, b = a.dup, d = T(1);

  foreach (i; 0..n) {
    auto p = i;
    foreach (j; i+1..n)
      if (b[p][i].abs < b[j][i].abs) p = j;
    swap(b[p], b[i]);
    foreach (j; i+1..n)
      foreach (k; i+1..n)
        b[j][k] -= b[i][k]*b[j][i]/b[i][i];
    d *= b[i][i];
    if (p != i) d = -d;
  }

  return d;
}

unittest
{
  auto u = Matrix!int.unit(2);
  assert(u[0] == [1, 0] && u[1] == [0, 1]);

  auto a = Matrix!int(2, 2);
  a[0] = [1, -1]; a[1] = [-2, 3];
  auto b = Matrix!int([[1, 2], [3, 4]]);
  b[0] = [1, 2]; b[1] = [3, 4];

  auto c0 = a.dup;
  assert(c0[0] == [1, -1] && c0[1] == [-2, 3]);

  auto c1 = a + b;
  assert(c1[0] == [2, 1] && c1[1] == [1, 7]);

  auto c2 = a - b;
  assert(c2[0] == [0, -3] && c2[1] == [-5, -1]);

  auto c3 = a * b;
  assert(c3[0] == [-2, -2] && c3[1] == [7, 8]);

  auto c4 = a * [1, 2];
  assert(c4 == [-1, 4]);

  import std.math;
  auto f = Matrix!real(3, 3);
  f = [[3, 4, -1], [2, 5, -2], [1, 6, -4]];
  auto g = f.det;
  assert((g + 7).abs < 1e-7L);
}
